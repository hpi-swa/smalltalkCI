# Preparation of Squeak Trunk images

*For 64/32-bit trunk images with update level 20447 or higher.*

```smalltalk
"Close wizard."
PreferenceWizardMorph allInstancesDo: [:ea | ea abandon].
"Ensure Metacello is loaded."
Metacello new.
"Ensure Tonel is loaded."
[ (Smalltalk classNamed: #MCTonelMissing) signal ] valueSupplyingAnswer: true.
"Clean up and save the image."
ReleaseBuilder deleteAllWindows.
Smalltalk garbageCollect.
Smalltalk condenseChanges.
Smalltalk snapshot: true andQuit: true.
```