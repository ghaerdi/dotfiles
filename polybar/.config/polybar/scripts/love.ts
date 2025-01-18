#!/usr/bin/env bun

const phrases = [
  "Cause I think I've fallen in love this time",
  "I blinked and suddenly had a valentine",
  "We are destined to love each other",
  "But life had to prepare us to be together first",
  "Para mí tú serás único en el mundo",
  "Y para ti yo seré único en el mundo",
  "Don't let me go",
  "Remember me"
];

const shuffle = <T>(array: T[]) => array.toSorted(() => Math.random() - 0.5);

console.log(shuffle(phrases).at(0));

