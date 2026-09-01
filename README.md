# Teamlage Offline

Taktisches Lageboard für Team-Status, Timer und Kartenmarkierungen.

- **Eigenes Bild**: läuft 100 % offline, keine Internetverbindung nötig.
- **Live-Karte**: nutzt OpenStreetMap. Einmal online geladene Kartenausschnitte
  bleiben danach auch offline verfügbar (Service Worker Cache).

Alle Team-/Einsatzdaten bleiben ausschließlich lokal im Browser-Speicher des
jeweiligen Geräts (IndexedDB/localStorage) – nichts davon wird an diesen
Server oder GitHub übertragen.

## Nutzung als App

- **iPad/iPhone**: Diese Seite in Safari öffnen → Teilen-Symbol → "Zum
  Home-Bildschirm". Läuft danach als eigenständige App-Kachel, auch offline.
- **Windows**: siehe `LIES-MICH.txt` für den lokalen App-Modus-Start.
