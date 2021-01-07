#include "timed_execution/timed_execution.as"
#include "timed_execution/level_event_job.as"

TimedExecution timer;

void Init(string level_name){
    timer.Add(LevelEventJob("knocked_over", function(_params){
        TransferCharAttribute(
            atoi(_params[1]),
            atoi(_params[2]),
            "p_fat",
            -1.0f,
            1.0f,
            0.1f,
            0.1f
        );
        return true;
    }));
    
    timer.Add(LevelEventJob("character_thrown", function(_params){
        TransferCharAttribute(
            atoi(_params[1]),
            atoi(_params[2]),
            "p_muscle",
            -1.0f,
            1.5f,
            0.1f,
            0.1f
        );
        return true;
    }));
    
    timer.Add(LevelEventJob("character_attack_missed", function(_params){
        TransferCharAttribute(
            atoi(_params[1]),
            atoi(_params[2]),
            "p_ear_size",
            0.5f,
            1.5f,
            0.1f,
            0.1f
        );
        return true;
    }));
}

void ReceiveMessage(string msg){
    timer.AddLevelEvent(msg);
}

void Update() {
    timer.Update();
}

bool HasFocus(){
    return false;
}

void DrawGUI() {}

void TransferCharAttribute(int id1, int id2, string parameter, float min_val, float max_val, float incre, float decre){
    MovementObject@ char1 = ReadCharacterID(id1);
    MovementObject@ char2 = ReadCharacterID(id2);

    float char1_val = char1.GetFloatVar(parameter) - decre;
    if(char1_val > min_val && char2.GetIntVar("knocked_out") == _awake){
        char1.Execute(parameter + " = " + char1_val + "f;");
        char1.Execute("ApplyBoneInflation();");
    }

    float char2_val = char2.GetFloatVar(parameter) + incre;
    if(char2_val < max_val && char1.GetIntVar("knocked_out") == _awake){
        char2.Execute(parameter + " = " + char2_val + "f;");
        char2.Execute("ApplyBoneInflation();");
    }
}

void PreScriptReload(){
    timer.DeleteAll();
}

void PostScriptReload(){
    Init("");
}
