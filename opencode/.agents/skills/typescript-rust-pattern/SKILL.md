---
name: typescript-rust-pattern
description: >-
  Apply Rust-inspired safety patterns to TypeScript code. Use this skill
  whenever writing or reviewing TypeScript — especially when adding types,
  handling errors, validating external data (APIs, file input, user input),
  designing state machines, or refactoring legacy code with loose booleans or
  try/catch. It covers four patterns: discriminated unions (eliminate impossible
  states), Result types (explicit failures), schema-based parsing at boundaries
  (parse don't validate), and explicit mutability. If the user is working with
  TypeScript and mentions any of these concepts, or if their code shows patterns
  like boolean overloads, untyped throw, or unchecked external data, apply this
  skill.
---

# TypeScript Rust Patterns

This skill helps you write safer, more maintainable TypeScript by adopting four
patterns inspired by Rust's type system. The goal is to make invalid states
unrepresentable at the type level and force callers to handle failures
explicitly.

## How to use this skill

When the user asks you to write, review, or refactor TypeScript code:

1. **Check what's available** — look at `package.json` (or `deno.json`,
   `importmap`, etc.) to see which of these libraries are already installed:
   - `@ghaerdi/rustify` (preferred for Result types)
   - `zod` (preferred for validation)
   - `yup`, `joi`, `valibot`, `@effect/schema`, or other schema libs
   - If nothing is available, use lightweight inline alternatives (explained below)
2. **Apply the relevant patterns** from the four sections below
3. **Explain your changes** briefly so the user understands the reasoning

## Pattern 1: Eliminate Impossible States with Discriminated Unions

### The problem

Boolean flags and nullable fields create *impossible states* — combinations the
type system accepts but that make no sense in practice.

```ts
// ❌ This type allows meaningless combinations
type UIState = {
  isLoading: boolean;
  isEmpty: boolean;
  error: Error | null;
  data: Data | null;
};
// What does isLoading=true + isEmpty=true + error=Error mean? It's a bug.
```

### The fix

Replace loose booleans with a discriminated union. Use `kind` as the
discriminant property name (not `status` or `type`). Each variant carries only
the data it needs — no more, no less.

```ts
// ✅ Only valid states are representable
type UIState =
  | { kind: "idle" }
  | { kind: "loading" }
  | { kind: "success"; data: Data }
  | { kind: "failed"; error: Error };
```

### Enforce exhaustiveness

Always add a `default` branch in switch statements that assigns the discriminant
to a `never` variable. If a new variant is added later, TypeScript will catch
every unhandled case at compile time.

```ts
function render(state: UIState): string {
  switch (state.kind) {
    case "idle":    return "Waiting...";
    case "loading": return spinner();
    case "success": return formatData(state.data);
    case "failed":  return errorBanner(state.error.message);
    default:
      // TypeScript error if a new variant is added without a case
      const _exhaustive: never = state.kind;
  }
}
```

### When to use this pattern

- **Form state**: Instead of `{ isSubmitting, isError, isSuccess, data, error }`,
  use `{ kind: "idle" | "editing" | "submitting" | "success" | "error" }`
  where each variant carries only relevant fields.
- **Async data loading**: Replace `{ isLoading, data, error }` with
  `{ kind: "loading" | "success"; data | "failed"; error }`.
- **Feature flags / toggles**: Use a union of string literals instead of
  multiple booleans.
- **Any state machine**: Model each state as a variant.

## Pattern 2: Explicit Failures with Result Types

### The problem

Try/catch makes failure paths invisible in function signatures. A caller can
call a function without knowing it might throw — the error path is hidden.

```ts
// ❌ No indication this can fail
function processPayment(amount: number): Receipt { /* may throw */ }
```

### The fix

Make expected errors part of the return type so callers *must* handle them.

#### If `@ghaerdi/rustify` is available (preferred)

```ts
import { Ok, Err } from "@ghaerdi/rustify";
import type { Result } from "@ghaerdi/rustify";

function processPayment(amount: number): Result<Receipt, PaymentError> {
  if (amount <= 0) return Err(PaymentError.InvalidAmount);
  // ... success path
  return Ok({ id: crypto.randomUUID(), total: amount });
}
```

Available methods: `.isOk()`, `.isErr()`, `.unwrap()`, `.unwrapOr(default)`,
`.unwrapOrElse(fn)`, `.match({ Ok, Err })`, `.map(fn)`, `.andThen(fn)`,
`.asTuple()`, `.asObject()`, `Result.from(fn)`, `Result.fromAsync(fn)`.

#### If no Result library is available

Create a lightweight inline Result type. Prefer a tag-based discriminated union
over an object with nullable fields.

```ts
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

function Ok<T>(value: T): Result<T, never> {
  return { ok: true, value };
}

function Err<E>(error: E): Result<never, E> {
  return { ok: false, error };
}
```

Usage with this inline type:

```ts
const result = processPayment(100);
if (result.ok) {
  console.log(result.value);
} else {
  console.error(result.error);
}
```

#### If Zod is available but not @ghaerdi/rustify

Zod's `.safeParse()` already returns a tagged Result-like type. Use it as a
pattern for other fallible operations too — return `{ success, data, error }`
shapes.

```ts
// Reuse the safeParse pattern for your own functions
function processPayment(amount: number): {
  success: true; data: Receipt
} | {
  success: false; error: PaymentError
} {
  if (amount <= 0) return { success: false, error: PaymentError.InvalidAmount };
  return { success: true, data: { id: crypto.randomUUID(), total: amount } };
}
```

### When to use this pattern

- **Domain operations** that can fail for expected reasons (payment, validation,
  auth, network calls).
- **Functions parsing/transforming data** where malformed input is possible.
- **Any operation currently using exceptions for control flow** — convert to
  Result so the type system enforces handling.

### What NOT to use this pattern for

- Internal assertions that truly should never fail (use `assert` or throw for
  programming errors, not Result).
- One-off cases where a null return is idiomatic (e.g., `Array.prototype.find`).

## Pattern 3: Boundary Validation — Parse, Don't Validate

### The problem

Validating the same data at every use site is repetitive, error-prone, and
destroys type safety — the type says `string` but your code assumes it's an
email everywhere.

### The principle

Validate untrusted data **once** at the system boundary (API handler, file
import, user input). After that, the type system guarantees the data is valid.
Every downstream function receives a trusted type and never needs to re-check.

#### If Zod is available

```ts
import { z } from "zod";
import type { Result } from "@ghaerdi/rustify";

const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
});

type User = z.infer<typeof UserSchema>;

function parseUser(raw: unknown): Result<User, z.ZodError> {
  const parsed = UserSchema.safeParse(raw);
  if (parsed.success) return Ok(parsed.data);
  return Err(parsed.error);
}

// After parsing, User is trusted everywhere:
function formatUserName(user: User): string {
  return user.email.split("@")[0];  // safe — email is validated
}
```

#### If yup, valibot, or another schema lib is installed

Use the same pattern — the library's parse/safeParse/cast function at the
boundary, then trust the inferred type downstream.

```ts
import * as yup from "yup";

const UserSchema = yup.object({
  email: yup.string().email().required(),
});

type User = yup.InferType<typeof UserSchema>;

function parseUser(raw: unknown): Result<User, yup.ValidationError> {
  try {
    return Ok(UserSchema.validateSync(raw));
  } catch (err) {
    return Err(err as yup.ValidationError);
  }
}
```

#### If no schema library is available

Use a branded type with a private constructor or a standalone parse function.

```ts
// Branded type — only this module can create valid instances
type Email = string & { __brand: "Email" };

function parseEmail(raw: string): Result<Email, Error> {
  if (typeof raw !== "string") return Err(Error("Email must be a string"));
  if (!/^[^\s@]+@[^\s@]+$/.test(raw)) return Err(Error("Invalid email"));
  return Ok(raw as Email);
}

// A function receiving Email never needs to re-validate:
function sendEmail(to: Email, body: string): void { /* ... */ }
```

Or use a class with a private constructor:

```ts
class ProductID {
  private constructor(public readonly value: string) {}

  static parse(raw: unknown): Result<ProductID, Error> {
    if (typeof raw !== "string" || !/^[A-Z]{3}-\d{5}$/.test(raw)) {
      return Err(Error("Invalid product ID format"));
    }
    return Ok(new ProductID(raw));
  }
}
```

### Where to put the boundary

- **API route handlers** — parse request bodies and query params here
- **File import functions** — parse CSV/JSON/XML at the read boundary
- **Constructor functions** for domain types — parse raw input, return Result
- **Library wrapper boundaries** — parse untrusted external API responses

### Guideline: prefer Zod over custom parsers

Zod gives you schema-driven type inference, detailed error messages, and
composition for free. Only write custom parsers when Zod isn't available and
you can't add it.

## Pattern 4: Local Mutations — Be Explicit About Mutability

### The problem

Functions that silently mutate their inputs are surprising. The caller doesn't
expect `cart` to change after calling `applyDiscount(cart)`.

### The fix

#### Default: return new objects

```ts
function applyDiscount(cart: Cart): Cart {
  return {
    ...cart,
    items: cart.items.map(item => ({
      ...item,
      price: item.price * 0.9,
    })),
  };
}
```

This is the default — it's safe, predictable, and works with immutable data
patterns.

#### When mutation is intentional: name it clearly

If mutation is necessary (performance, builder pattern, in-place updates), make
it obvious from the function name.

```ts
function sortInPlace(arr: Mutable<Data[]>): void {
  arr.sort((a, b) => a.id - b.id);
}
```

Use `Mutable<T>` to signal the intent:

```ts
type Mutable<T> = { -readonly [K in keyof T]: T[K] };
```

#### Local mutation is fine

Mutating local variables inside a function is safe — there's no external effect.

```ts
function calculateTotal(items: Item[]): number {
  let sum = 0;
  for (const item of items) {
    sum += item.price * item.qty; // local mutation — no external effect
  }
  return sum;
}
```

#### Builder pattern: mutate internally, return immutably

Builders are a good use case for contained mutation:

```ts
class QueryBuilder {
  private filters: string[] = [];

  addFilter(f: string): this {
    this.filters.push(f);
    return this;
  }

  build(): Query {
    return { where: this.filters.join(" AND ") };
  }
}
```

### When to mutate vs. return new

| Situation | Approach |
|---|---|
| Simple transformation (map, filter, spread) | Return new object |
| Performance-critical hot path with large data | Mutate in place, name with `InPlace` suffix |
| Builder pattern | Mutate internally, return `this` |
| Local accumulator (sum, counter, array push) | Use `let`, it's fine |
| Cross-cutting state (cache, registry) | Encapsulate in a class, document as mutable |

## Decision guide: putting it all together

When faced with a TypeScript code problem, use this flow:

1. **Is external/untrusted data involved?** → Apply Pattern 3 (parse at boundary
   with Zod or equivalent, return a Result)

2. **Does the operation have expected failure modes?** → Apply Pattern 2 (return
   a Result instead of throwing)

3. **Is there a state machine or multi-state UI?** → Apply Pattern 1
   (discriminated union with `kind`, exhaustive switch)

4. **Is there a function that might mutate something?** → Apply Pattern 4 (name
   it clearly, prefer immutable returns)

5. **Are you writing a new function signature?** → Always return a Result if
   failure is an expected possibility. Let exceptions only represent
   *unexpected* programming errors (assertions, out-of-memory, etc.).

## What to check in a code review

When reviewing TypeScript code, look for these red flags:

- ❌ Booleans used as state flags (`isLoading`, `isError`, `isSuccess`)
- ❌ Functions that throw for expected errors (network, validation, auth)
- ❌ Untrusted data used without validation (any API response, any `req.body`)
- ❌ Functions that silently mutate their arguments
- ❌ `any` type used where a discriminated union or Result would fit
- ❌ Catch blocks that swallow errors or log and return a default

And suggest these green flags instead:

- ✅ Discriminated unions with `kind` and exhaustive `never` checks
- ✅ Result return types for fallible operations
- ✅ Zod (or equivalent) parsing at API/file boundaries
- ✅ Immutable-by-default functions, `InPlace` suffix for mutating ones
- ✅ `type` imports for type-only exports (`import type { Result }`)
