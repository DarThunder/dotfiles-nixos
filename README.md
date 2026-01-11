# Ironic, isn’t it?

> _From “I use Arch btw” to “my system is a pure function.”_

This repository contains **my personal NixOS dotfiles**.
They are opinionated, slightly over-engineered, and intentionally **not** meant to be a drop-in solution for anyone else.

That said, if you’re here to:

- learn how to structure **clean Nix flakes**
- see how a former Arch user copes with **immutability**
- or just enjoy the irony

…you’re welcome to stay.

---

## What this is (and what it isn’t)

This repo is:

- My **daily-driver NixOS configuration**
- A place where I encode how _my_ system should behave
- A practical example of **flakes that scale without becoming unreadable**

This repo is **not**:

- A general-purpose NixOS starter pack
- A “clone and profit” config
- A minimal setup (Arch already scratched that itch)

If you try to use this verbatim and it breaks:
that’s not a bug, that’s a boundary.

---

## Why NixOS (yes, I know)

Yes, I loved Arch.
Yes, I still respect the philosophy.
Yes, this is ironic.

But after years of manually maintaining systems, I wanted:

- Reproducibility without ritual
- Declarative configs instead of tribal knowledge
- A system that can be **rebuilt**, not just repaired

NixOS doesn’t replace Arch’s philosophy —
it **formalizes** it.

Still hurts a little. Worth it.

---

## What’s inside

High-level overview (details are intentionally left to the reader):

- System configuration split into **logical modules**
- Home configuration managed declaratively
- Explicit decisions over defaults
- Minimal magic, maximal intent

Everything here exists because at some point I asked:

> “Do I really want to debug this again in six months?”

If the answer was “no”, it became declarative.

---

## Why it’s personal (but still useful)

These dotfiles encode:

- my hardware
- my workflows
- my tolerance for complexity

So no, this isn’t portable.

But if you’re trying to:

- understand how to organize flakes sanely
- avoid a single `flake.nix` god-file
- keep configs readable as they grow

…this repo can still serve as a **reference**, not a template.

Steal ideas, not assumptions.

---

## A note for Arch users reading this 👀

You’re not weaker for wanting reproducibility.
You’re not betraying anything.

You’re just choosing a different kind of control.

Also yes, I still say “btw”.

---

## Final disclaimer

This repo exists primarily so **future me** doesn’t suffer.

If it helps you too, that’s a bonus.
If it confuses you, that’s expected.

Welcome to declarative chaos.
