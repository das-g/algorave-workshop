Tidal Cycles and Strudel
===

[Tidal Cycles](https://tidalcycles.org/) is a live coding language for music
written in haskell, created by Alan Hickey. You write short, looping patterns of sound:

```haskell
 d1 $ sound "bd sd bd sd"
 d2 $ sound "bd [sd cp]*2"
```

Tidal Cycles live
===

Patterns are evaluated on numbered tracks (`d1`, `d2`, ...). Each pattern loops
forever and is sent to the sound engine:

```haskell
 d1 $ sound "bd sd bd sd"
 d2 $ sound "bd [sd cp]*2"
```

> To hear sound, the sound engine (`superdirt-start`) must be running - see the
> README.

Strudel
===

[Strudel](https://strudel.cc) is the modern successor to Tidal Cycles:

- Simlar pattern language, upgraded audio engine
- Runs entirely in your browser
- Edit patterns live, while the music plays

Building blocks
===

```javascript
[0 2 4 7]   // sequence: one step at a time
~           // rest
<0 2>       // stack: both, in the same step
[0 1]!2     // repeat
0@16        // offset: start one sixteenth later
```

Musical scales
===

`n` plays scale degrees. The scale does the music theory for you!

```javascript
$: n("[0 [~ 0] 4 [3 2] [0 ~] [0 ~] <0 2> ~]")
  .scale("D2:minor")
$: s("[bd - sd - - bd sd -], hh*8, [- oh]*2").bank("RolandTR909")
```

Effects
===

```javascript
$: note("[~ [<[d3,a3,f4]!2 [d3,bb3,g4]!2> ~]]*2")
  .sound("gm_electric_guitar_muted")
  .delay(.5)
```

Chain as many as you like: `.room`, `.lpf`, `.gain`, `.delay`

Our example song
===

`example/example.strudel`

```javascript
$: note("[~ [<[d3,a3,f4]!2 [d3,bb3,g4]!2> ~]]*2")
  .sound("gm_electric_guitar_muted").delay(.5)

$: sound("bd rim").bank("RolandTR707").delay(.5)

$: n("<4 [3@3 4] [<2 0> ~@16] ~>")
  .scale("D4:minor").sound("gm_accordion:2")
  .room(2).gain(.4)

$: n("[0 [~ 0] 4 [3 2] [0 ~] [0 ~] <0 2> ~]/2")
  .scale("D2:minor")
  .sound("sawtooth,triangle").lpf(200)
```

Four channels: guitar, drums, melody, bass.
