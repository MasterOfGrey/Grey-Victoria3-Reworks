# Grey's Victoria 3 Reworks Contributing Guide
Welcome and thank you for your interest.

The project spans multiple mods as sub-projects. If you would like to contribute to one, or several mods, you are welcome to do so!

In particular you are *always* welcome to contribute:

* New/Updated localization translations to non-english languages.
* Updates to any descriptions/documentations.
* New/Improved gfx (icons/images/etc.)
* Bugfixes from the error log.

## Project Overview

The goal I have with all of the mods in this collection is to create a dynamic and vibrant gameplay experience, where choices are meaningful and have consequences, no single option is always best, the player has the tools to effect change in ways that feel logical, and importantly, that the AI can interact with all these things as functionally as possible.

## Ground Rules

Please remember that ultimately all these mods are published under my name with the weight of my reputation, and also that they are borne from my love for actually playing the game. This means that if you're proposing things which I don't actually want to play I will reserve the right to say that those belong elsewhere. (Depending on time and capacity, I may support other mods elsewhere, refer to my Patreon for details.)
I am also only 1 person, and anyone else helping out here is likely doing it out of nothing more than their love of the game, so please be respectful of our time.

## Community Engagement

The absolute best place to connect with the project is via the Discord server: [Grey's Mods](https://discord.gg/SnUghEkQQz)

If you would like to stay up to date with news and participate in major community discussions or votes please refer to the Patreon.

## Before You Start

Ensure you have a github account and are familiar with the process of forking a repository, making edits in branches, and opening pull requests.

Unless you are submitting localizations, documentation,, gfx (icons/images/etc.), or bugfixes; join the discord and discuss your proposed contribution first.

## Best Practices

If possible, please:

* Edit only 1 mod subproject in 1 pull request (compatibility patches may be part of the same PR as the parent mod)
* Name pull requests in the format "`mod code` - `description of change`" (e.g. "PLP - Fix vanilla movement disband logic")

## Content style guide

File names are formatted "MoG_`mod code`_`content descriptor`".
File names may have a prefix to control intended compatibility outcomes:
* "a" - bonus features that don't hurt anything if they're overwritten by another mod.
* "b" - compatibility patches on "a" files
* no prefix - standard mod content.
* "v" - in built compatibility hacks that leave namespace for other patches to overwrite them.
* "y" - important features that need to be activated consistently which many mods touch frivilously, or which are not obvious to players when trying to work out which mods are compatible with each other (e.g. tiny edits to laws are often randomly included in other mods).
* "z","zzz", etc. - patch files explicitly intended to ensure compatibility.

## Report Issues and Bugs

Please report issues via the Discord if you are able to.