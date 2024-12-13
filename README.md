# Underwater Photogrammetry App

Dette projekt er en macOS-app, der udtrækker frames fra en videofil ved hjælp af `ffmpeg` og bruger Apples Object Capture API til at generere 3D-modeller. Formålet er at give brugeren en enkel grænseflade, hvor de kan:

1. Vælge en videofil.
2. Vælge en billedhastighed (FPS) for at udtrække frames.
3. Vælge en målmappe til de udtrukne frames.
4. Derefter bruge disse frames i en fotogrammetriproces.

## Krav

- **macOS Monterey (12.0) eller nyere**  
  PhotogrammetrySession API kræver mindst macOS Monterey.
  
- **Apple Silicon Mac (M1, M2, osv.) anbefales**  
  Object Capture er optimeret til Apple Silicon. Hvis du bruger Intel Mac, skal du måske bruge Rosetta.

- **Xcode 13.1 eller nyere**  
  For at kompilere SwiftUI-projekter med Object Capture API.

## Installation af ffmpeg

### Medfølgende ffmpeg
Projektet inkluderer en forkompileret `ffmpeg`-binær i `Resources`-mappen. Denne binær er pakket direkte ind i appen, så brugerne ikke skal installere ffmpeg selv.

### Forberedelse af ffmpeg
1. Sørg for at du har en statisk kompileret `ffmpeg`-binær.  
   Hvis du hentede en `.7z`-fil, skal du først udpakke den ved hjælp af et program som Keka eller The Unarchiver.

2. Giv `ffmpeg` eksekveringsrettigheder:
   ```bash
   chmod +x ffmpeg
Fjern evt. quarantine-attribut:

bash
Kopier kode
xattr -d com.apple.quarantine ffmpeg
Træk ffmpeg ind i projektets Resources-mappe i Xcode. Sørg for, at ffmpeg er tilføjet under "Build Phases > Copy Bundle Resources", så den pakkes med i appen.

Kørsel af projektet
Åbn projektet i Xcode.
Vælg "My Mac" som build destination.
Klik på "Run" (den grønne play-knap).
Når appen starter:

Klik på "Vælg Video" for at vælge en .mp4 eller .mov fil.
Justér FPS-slideren for at vælge, hvor mange frames pr. sekund du vil udtrække.
Klik på "Vælg Målmappe til Frames" for at vælge en mappe, hvor billederne skal gemmes.
Klik på "Udtræk Frames" for at køre ffmpeg. Frames vil blive gemt som frame_0001.png, frame_0002.png, osv.
Når du har dine frames, kan du bruge appens fotogrammetridel (hvis implementeret) til at generere en 3D-model.

Fejlfinding
Hvis ffmpeg ikke kan køre, så kontroller at ffmpeg ligger i Resources-mappen og har de rette eksekveringsrettigheder.
Hvis du får fejl om "Photogrammetry failed", kontroller at du bruger et passende sæt billeder (tabsløst format som PNG anbefales).
Sørg for, at der er tilstrækkeligt med billeder (typisk 20-30+) og god belysning.
Hvis du bruger Apple Silicon og binæren er kompileret til Intel, skal du muligvis installere Rosetta:
bash
Kopier kode
softwareupdate --install-rosetta
Licens
Projektet bruger ffmpeg, der er licenseret under LGPL/GPL. Sørg for at overholde licenskravene, hvis du distribuerer denne app.

Kontakt
Hvis du har spørgsmål eller problemer, opret gerne en issue i Git-repoen.
