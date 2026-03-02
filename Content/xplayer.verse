using { /Verse.org/Simulation }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Characters }

xplayer := class():
    Agent : agent
    var InitializedUI : logic = false
    var SelectedCategory : category = category{}
    var CurrentPage : int = 0

    var Item1Event : ?type{_(:xplayer):void} = false
    var Item2Event : ?type{_(:xplayer):void} = false
    var Item3Event : ?type{_(:xplayer):void} = false
    var Item4Event : ?type{_(:xplayer):void} = false
    var Item5Event : ?type{_(:xplayer):void} = false
    var Item6Event : ?type{_(:xplayer):void} = false

    Initialize():void=
        {}