using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/FortPlayerUtilities }
using { /UnrealEngine.com/Temporary/SpatialMath }
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

    OnBegin<override>()<suspends>:void=
        InitiatePlayerSpawners()
        EliminationManager.EliminatedEvent.Subscribe(OnPlayerEliminated)

    InitiatePlayerSpawners():void=
        for (PlayerSpawner : PlayerSpawners):
            PlayerSpawner.SpawnedEvent.Subscribe(OnPlayerSpawned)

    OnPlayerSpawned(Agent : agent):void=
        xPlayer : xplayer = xplayer{Agent := Agent}
        set xPlayers += array{xPlayer}
        MaterialItemGranter.GrantItemIndex(xPlayer.Agent, 0)

    OnPlayerEliminated(Agent : agent):void=
        spawn{RespawnPlayer(Agent)}

    RespawnPlayer(Agent : agent)<suspends>:void=
        Sleep(0.1)
        Agent.Respawn(vector3{}, rotation{})
        PlayerTeamIndex := GetAgentTeamIndex(Agent)
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