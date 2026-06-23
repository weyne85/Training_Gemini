# Training_Gemini

## Schritt-für-Schritt Anleitung für den Mission Editor (ME)
DCS benötigt spezifische Logistik-Objekte in einem Radius von ca. 150 Metern umeinander, damit Hubschrauber dort nativ über das Funkmenü reparieren, aufmunitionieren und auftanken können.

1. Erstellung der Einheiten & Zonen im ME:
- Träger-Pickup-Zone: Erstelle eine kreisrunde Trigger-Zone mit dem Namen Träger_Zone direkt über deinem Flugzeugträger.

- Chinook: Platziere eine CH-47F Chinook als Client oder Player. Stelle sicher, dass sie vom Träger oder in der Nähe startet.

- Die FARP-Template-Gruppe: Erstelle eine neue Boden-Gruppe (Koalition: Blau) mit dem exakten Gruppennamen FARP_Komplett_Gruppe. Setze unbedingt den Haken bei Late Activation (Späte Aktivierung). Diese Gruppe enthält alle Einheiten, die CTLD beim Entpacken der Kiste an Ort und Stelle spawnen soll:

- Einheit 1 (ATC/TACAN): Ein M1025 HMMWV (oder ein anderes Führungsfahrzeug). Nenne den Unit-Namen (Einheiten-Namen) dieser spezifischen Einheit exakt: FARP_ATC_Einheit. (Hier dockt das TACAN-Skript an).

- Einheit 2 (Tanken): Ein M978 Heavy Tactical Truck (wichtig für die native DCS-Tankfunktion).

- Einheit 3 (Aufmunitionieren): Ein M818 LKW (wichtig für die native DCS-Munitionsfunktion).

- Einheit 4 & 5 (Bodenabwehr): Ein oder zwei Leopard 2 Panzer.

- Einheit 6 & 7 (Flugabwehr): Ein oder zwei Flakpanzer Gepard.

- Einheit 8-12 (Infanterie): Füge der Gruppe beliebig viele Infanteristen (Soldaten mit Gewehren oder Stinger) hinzu.

Hinweis für maximale Immersion: Du kannst auch ein statisches Objekt vom Typ "FARP CP ISO" oder ein unsichtbares FARP-Pad in die Template-Gruppe packen, DCS-technisch reichen jedoch die oben genannten Fahrzeuge (M978 und M818) vollkommen aus, um jede Freifläche im Umkreis von 150m in eine voll funktionsfähige Tank- und Munitionszone zu verwandeln.

## Ablauf im Spiel (Praxistest):
Fliege mit der Chinook zum Carrier.

Öffne das Funkmenü: F10 Andere -> CTLD -> Crates -> Spawn Crate -> Wähle "Militärisches FARP (Komplett)".

Eine Kiste wird auf dem Deck gespawnt. Gehe im Schwebeflug darüber und nimm sie als Außenlast (Sling Load) auf.

Fliege an deinen vordefinierten Zielort im Landesinneren und setze die Kiste vorsichtig ab.

Lande daneben, öffne das Funkmenü: CTLD -> Crates -> Unpack closest crate.

Die Kiste verschwindet und deine komplette Verteidigungs- und Logistikarmee steht sofort einsatzbereit vor dir. Nach maximal 5 Sekunden schaltet sich der TACAN-Sender (16X) automatisch auf dem Führungsfahrzeug auf.

## Aktivierungs-Reihenfolge im ME-Trigger-Menü:
- Trigger 1: MISSION START -> Keine Bedingung -> DO SCRIPT FILE -> mist.lua laden.

- Trigger 2: MISSION START -> Keine Bedingung -> DO SCRIPT FILE -> Moose.lua laden.

- Trigger 3: MISSION START -> Keine Bedingung -> DO SCRIPT FILE -> ctld.lua laden.

- Trigger 4: ONCE -> TIME MORE (5) -> DO SCRIPT FILE -> Dieses obige Skript laden.
