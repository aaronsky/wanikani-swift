# ``WaniKani``

A Swift library and client for the WaniKani REST API.

## Overview

The entire publicly-documented REST API surface is supported by this package.

## Topics

### Essentials

- <doc:GettingStarted>
- ``WaniKani/WaniKani``
- ``ResponseError``

### Resources

- ``Assignments``
- ``LevelProgressions``
- ``Resets``
- ``Reviews``
- ``ReviewStatistics``
- ``SpacedRepetitionSystems``
- ``StudyMaterials``
- ``Subjects``
- ``Summaries``
- ``Users``
- ``VoiceActors``
- ``Resource``
- ``ModelProtocol``
- ``ModelCollection``

### Models

- ``Assignment``
- ``LevelProgression``
- ``Reset``
- ``Review``
- ``ReviewStatistic``
- ``SpacedRepetitionSystem``
- ``StudyMaterial``
- ``Summary``
- ``User``
- ``VoiceActor``

### Subjects

Subjects are a special variant type with some shared properties. They can be one of three model types: ``Radical``, ``Kanji``, or ``Vocabulary``.

- ``Subject``
- ``Radical``
- ``Kanji``
- ``Vocabulary``
- ``Meaning``
- ``AuxiliaryMeaning``
- ``SubjectProtocol``

### Architecture

- ``Response``
- ``StatusCode``
- ``Page``
- ``PageOptions``
- ``Transport``
- ``WaniKani/WaniKani/APIVersion``
- ``WaniKani/WaniKani/Configuration-swift.struct``
