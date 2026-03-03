using { /Verse.org/Simulation }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Characters }

item_data := struct:
    Event : type{_(:xplayer, :int):void}
    Data : item

Preset(xPlayer : xplayer, Index : int):void=
    block:

xplayer := class():
    Agent : agent
    var InitializedUI : logic = false
    var SelectedCategory : category = category{}
    var SelectedItems : []item = array{}
    var CurrentPage : int = 0

    var Item1Data : item_data = item_data{Event := Preset, Data := item{}}
    var Item2Data : item_data = item_data{Event := Preset, Data := item{}}
    var Item3Data : item_data = item_data{Event := Preset, Data := item{}}
    var Item4Data : item_data = item_data{Event := Preset, Data := item{}}
    var Item5Data : item_data = item_data{Event := Preset, Data := item{}}
    var Item6Data : item_data = item_data{Event := Preset, Data := item{}}

    Initialize():void=
        {}