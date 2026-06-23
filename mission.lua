-- ============================================================================

-- MOOSE & CTLD ENHANCED MISSION: AIRBOSS, RANGE, RAT & FARP-LOGISTICS

-- ============================================================================



-- Globale Variable zur Vermeidung von Fehlern mit nicht existierenden UNIT-Flag-Methoden

local farpTacanAktiv = false



-- 1. AIRBOSS CONFIGURATION (Trägeroperationen)

-- ----------------------------------------------------------------------------

-- AIRBOSS:New erwartet den String-Namen des Trägers im Mission Editor (ME).

local myAirboss = AIRBOSS:New("Träger_Einheit_Name")

myAirboss:SetSoundfilesFolder("Airboss Soundfiles/")



-- 5. Argument auf 'false' -> Träger dreht sich NICHT automatisch in den Wind

myAirboss:AddRecoveryWindow("20:00", "23:00", 3, nil, false)



-- Träger-Refueling-Tanker (Direkt in den Airboss integriert)

-- Die Übergabe erfolgt per String-Namen, um nil-Pointer beim Laden zu verhindern.

local myTanker = RECOVERYTANKER:New("Träger_Einheit_Name", "Tanker_Gruppe_Name")

myTanker:SetTakeoffAir()

myTanker:SetAltitude(6000)

-- Wichtig: myTanker:Start() darf NICHT gerufen werden, wenn der Airboss das Management übernimmt!

myAirboss:SetRecoveryTanker(myTanker)



-- Träger-Rescue-Helo (Direkt in den Airboss integriert)

local myRescueHelo = RESCUEHELO:New("Träger_Einheit_Name", "RescueHelo_Gruppe_Name")

myRescueHelo:SetTakeoffHot()

myAirboss:SetRescueHelo(myRescueHelo)



-- AWACS-Konfiguration über stabiles MOOSE SPAWN (E-2 verträgt keine Tanker-Tasks)

-- Diese Logik sorgt für ein ununterbrochenes 24/7 AWACS-Coverage.

local myAwacsSpawn = SPAWN:New("AWACS_Gruppe_Name")

myAwacsSpawn:InitLimit(1, 0) -- Maximal 1 aktives AWACS gleichzeitig, unendliche Respawns

myAwacsSpawn:InitRepeatOnEngineShutdown() -- Spawnt automatisch Ersatz, sobald das AWACS landet oder abgeschaltet wird

myAwacsSpawn:SpawnScheduled(10, 0) -- Erster Spawn erfolgt sicher 10 Sekunden nach Missionsstart



-- Startet das gesamte Träger-FSM

myAirboss:Start()



-- 2. RANGE CONFIGURATION (Schießplatz & Trefferauswertung)

-- ----------------------------------------------------------------------------

local myRange = RANGE:New("Übungsplatz_Name")

myRange:SetSoundfilesFolder("Range Soundfiles/") -- Behoben: 'SetSoundfilesFolder' statt 'SetSoundfilesPath'

myRange:SetInstructorRadio(275)

myRange:SetRangeControl(395)

myRange:AddBombingTargets({"Bomben_Ziel_1", "Bomben_Ziel_2"}, 30)

myRange:AddStrafePit({"Strafe_Ziel_1", "Strafe_Ziel_2"}, 3000, 300, nil, true, 20)

myRange:Start()



-- 3. RAT CONFIGURATION (Ziviler Zufallsflugverkehr)

-- ----------------------------------------------------------------------------

local myRat = RAT:New("RAT_Zivil_Template")

myRat:Spawn(5)



-- 4. CTLD ENHANCEMENT (FARP Außenlast-Logistikaufgabe)

-- ----------------------------------------------------------------------------

if ctld then

    -- Füge eine CTLD-Pickup-Zone direkt auf dem Flugzeugträger hinzu.

    table.insert(ctld.pickupZones, { "Träger_Zone", "blue", smoke = false, limit = -1 })



    -- Definiere die Kiste für das zweiseitig funktionale FARP

    -- Behoben: Keys an die offizielle CTLD-API angepasst (name, crateType, cratesRequired, unitTemplate)

    table.insert(ctld.spawnableCrates, {

        name = "Militärisches FARP (Komplett)",

        crateType = "FARP_Baukiste",

        cratesRequired = 1,

        unitTemplate = "FARP_Komplett_Gruppe", -- Exakter Gruppenname der Vorlage im ME

        isVehicle = false

    })

end



-- 5. MOOSE SCHEDULER FOR FARP AUTOMATION (ATC & TACAN-Aktivierung)

-- ----------------------------------------------------------------------------

-- Wir filtern dynamisch nach dem Präfix des CTLD-Spawns, da CTLD Suffixe anhängt (z.B. "... #001").

local farpUnitSet = SET_UNIT:New():FilterPrefixes("FARP_ATC_Einheit"):FilterOnce()



SCHEDULER:New(nil, function()

    -- Aktualisiert das Filter-Set im laufenden Betrieb

    farpUnitSet:FilterOnce()

    local farpAtcUnit = farpUnitSet:GetFirst()

   

    if farpAtcUnit and farpAtcUnit:IsAlive() and not farpTacanAktiv then

        -- Schaltet TACAN auf der ATC-Einheit ein (Kanal 16X, Kennung: FRP)

        farpAtcUnit:CommandBeaconTACAN(16, "X", "FRP", true)

        farpTacanAktiv = true

        trigger.action.outText("+++ SYSTEM: FARP erfolgreich errichtet! TACAN Kanal 16X (FRP) und ATC sind online! +++", 10)

    end

end, {}, 5, 5)
