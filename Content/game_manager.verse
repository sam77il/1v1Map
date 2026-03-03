using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }

game_settings := struct:
    MaxHealth : float
    MaxShield : float

game_manager := class(creative_device):
    @editable
    PlayerSpawners : []player_spawner_device = array{}

    @editable
    Teleporters : []teleporter_device = array{}

    @editable
    MaterialItemGranter : item_granter_device = item_granter_device{}

    @editable
    EliminationManager : elimination_manager_device = elimination_manager_device{}

    var xPlayers : []xplayer = array{}
    var GameSettings : game_settings = game_settings{
        MaxHealth := 100.0
        MaxShield := 100.0
    }

    OnBegin<override>()<suspends>:void=
        InitiatePlayerSpawners()
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeft)
        EliminationManager.EliminatedEvent.Subscribe(OnPlayerEliminated)

    OnPlayerLeft(Agent : agent):void=
        for (I := 0..xPlayers.Length - 1):
            if (xPlayers[I].Agent = Agent):
                if (Result := xPlayers.RemoveElement[I]):
                    set xPlayers = Result

    InitiatePlayerSpawners():void=
        for (PlayerSpawner : PlayerSpawners):
            PlayerSpawner.SpawnedEvent.Subscribe(OnPlayerJoined)

    OnPlayerJoined(Agent : agent):void=
        xPlayer : xplayer = xplayer{Agent := Agent}
        set xPlayers += array{xPlayer}
        MaterialItemGranter.GrantItemIndex(xPlayer.Agent, 0)
        Participants := GetPlayspace().GetParticipants()

        Reset1v1()

    Reset1v1():void=
        Participants := GetPlayspace().GetParticipants()

        for (Participant : Participants):
            spawn:
                RespawnPlayer(Participant, true)
    
    OnPlayerEliminated(Agent : agent):void=
        Reset1v1()

    RespawnPlayer(Agent : agent, Revive : logic)<suspends>:void=
        Sleep(0.1)
        if (Revive?):
            Agent.Respawn(vector3{}, rotation{})

            if (FortCharacter := Agent.GetFortCharacter[]):
                FortCharacter.SetMaxHealth(GameSettings.MaxHealth)
                FortCharacter.SetMaxShield(GameSettings.MaxShield)
                FortCharacter.SetHealth(GameSettings.MaxHealth)
                FortCharacter.SetShield(GameSettings.MaxShield)

        PlayerTeamIndex := GetAgentTeamIndex(Agent)

        if (PlayerTeamIndex >= 0):
            if (Teleporter := Teleporters[PlayerTeamIndex]):
                Teleporter.Teleport(Agent)
        

    GetAgentTeamIndex(Agent : agent):int=
        TeamCollection := GetPlayspace().GetTeamCollection()
        if(
            PlayerTeam := TeamCollection.GetTeam[Agent]
            VerseTeamIndex := TeamCollection.GetTeams().Find[PlayerTeam]
        ):
            return VerseTeamIndex
            
        return -1