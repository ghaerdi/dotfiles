---
name: zustand-state
version: 1.0.0
description: Expert in Zustand state management for React. Covers store creation, TypeScript integration, middleware (persist, immer), selector patterns, and best practices for avoiding unnecessary re-renders.
---

# Zustand State Management

Zustand is a small, fast, and scalable bear-bare-bones state management solution for React.

<when_to_use>

- Replacing complex Redux setups with a simpler API
- Managing global state that needs to be accessed across multiple components
- Implementing persisted state (localStorage/sessionStorage)
- When you need a store that can be accessed outside of React components
- Avoiding "prop drilling" for frequently used global data

NOT for: purely local component state (use useState/useReducer), deeply nested complex relational data (consider TanStack Query or a dedicated DB)

</when_to_use>

<store_creation>

**Basic Typed Store**:
Define the state and actions in a simple type and a store hook.

```typescript
import { create } from 'zustand';

type NectarUserState = {
	user: IUser | undefined;
	setUser: (user: IUser) => void;
};

export const useNectarUserStore = create<NectarUserState>((set) => ({
	user: undefined,
	setUser: (user) => set({ user }),
}));
```


</store_creation>

<selectors_and_performance>

**Atomic Selectors** (Prevent Re-renders):
Use selectors to pull only the required state. This ensures the component only re-renders when the selected value changes.

```typescript
// Inline selector for simple values
const userName = useNectarUserStore((state) => state.user?.name);
```

**Selecting Multiple Fields**:
Use `useShallow` to prevent re-renders when returning a new object or array from a selector.

```typescript
import { useShallow } from 'zustand/react/shallow';

function Navbar() {
  // Only re-renders if userName or isLoggedIn actually change
  const { userName, isLoggedIn } = useNectarUserStore(
    useShallow((state) => ({ 
      userName: state.user?.name, 
      isLoggedIn: !!state.user 
    }))
  );
}
```

</selectors_and_performance>

<middleware>

**Persist**: Keep state across page refreshes.

```typescript
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

type SettingsState = {
	theme: 'light' | 'dark';
	setTheme: (theme: 'light' | 'dark') => void;
};

export const useSettingsStore = create<SettingsState>()(
	persist(
		(set) => ({
			theme: 'light',
			setTheme: (theme) => set({ theme }),
		}),
		{
			name: 'settings-storage', // key in localStorage
		}
	)
);
```

</middleware>

<outside_react>

Zustand stores can be used outside of components (e.g., in API interceptors or utility functions).

```typescript
// Access state without a hook
const currentUser = useUserStore.getState().userName;

// Update state without a hook
useUserStore.setState({ isLoggedIn: false });

// Subscribe to changes
const unsub = useUserStore.subscribe((
  state, 
  prevState
) => {
  console.log('State changed from', prevState, 'to', state);
});
```

</outside_react>

<rules>

ALWAYS:
- Use atomic selectors to minimize re-renders
- Use `useShallow` when selecting multiple fields into an object
- Type the store using `create<T>()` for full TypeScript support
- Prefer `getState()` and `setState()` for logic that lives outside React components

NEVER:
- Return the entire store object inside a component `useStore()` call
- Create multiple stores for data that is logically part of one entity
- Forget to define the store type for TypeScript

</rules>
