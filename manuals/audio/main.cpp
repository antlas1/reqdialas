#include <string>
#include <iostream>
#include <thread> //для доступа к текущему потоку
#include <chrono> //для ожидания в секундах
//сначала vorbis только дефайны
#define STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"    

//теперь весь миниаудио, подтягивает дефайны ворбиса
#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"

//vorbis реализацию
#undef STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"   

static ma_engine snd_engine;

bool initSound()
{
    ma_result result = ma_engine_init(NULL, &snd_engine);
    if (result != MA_SUCCESS) {
        std::cout << "Failed init sound engine\n";
        return false;  // Failed to initialize the engine.
    }
    return true;
}

void playSound(std::string sound_file_name)
{
    ma_engine_play_sound(&snd_engine, sound_file_name.c_str(), NULL);
}

void writeOutput(const std::string& output)
{
    std::cout << output;
}

std::string readUserInput()
{
    std::string input;
    std::getline(std::cin, input);
    return input;
}

bool runGameStep(const std::string& userCmd, std::string& gameOutput)
{
    if (userCmd == "NO")
    {
        gameOutput = "OK. May be next time.\n";
        playSound("next.ogg");
        return true;
    }
    
    gameOutput = "BYE-BYE!\n";
    playSound("tuturu.ogg");
    return false;
}

int main(int argc, char* argv[])
{
    if (!initSound())
    {
        return EXIT_FAILURE;
    }
    const std::string prompt(">");
    writeOutput("Stub game. Print text and exit! If NO, continue game.\n");
    playSound("start.ogg");
    writeOutput(prompt);
    while (true) 
    {
        std::string userCmd = readUserInput();
        std::string gameOutput;
        bool allowNext = runGameStep(userCmd, gameOutput);
        writeOutput(gameOutput);
        if (!allowNext) break;
        writeOutput(prompt);
    }
    //ожидание для того чтобы звук успел отыграть
    std::this_thread::sleep_for(std::chrono::seconds(2));
    return EXIT_SUCCESS;
}