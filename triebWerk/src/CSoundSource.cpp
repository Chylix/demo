#include "CSoundSource.h"
#include <fstream>
#include <iostream>

triebWerk::CSoundSource::CSoundSource()
	: m_AudioBufferByteSize(0)
	, m_AudioData(nullptr)
	, m_Volume(1.0f)
{
}

triebWerk::CSoundSource::~CSoundSource()
{
	if(m_AudioData != nullptr)
		delete m_AudioData;
}

bool triebWerk::CSoundSource::LoadSoundDataFromFile(const char * a_pPath)
{
	FILE* pFile = nullptr;

	char charBuffer[4] = { 0 };
	long followingContentSize = 0;

	long chunkContentSize = 0;

	fopen_s(&pFile, a_pPath, "rb");

	if (pFile == nullptr)
		return false;

	//Read first Header
	fread(&charBuffer, sizeof(char) * 4, 1, pFile);
	if (strncmp(charBuffer, "RIFF", 4) != 0)
		return false;

	fread(&followingContentSize, sizeof(long), 1, pFile);

	fread(&charBuffer, sizeof(char) * 4, 1, pFile);
	if (strncmp(charBuffer, "WAVE", 4) != 0)
		return false;

	//Iterate over all chunks
	while (ftell(pFile) != followingContentSize + 8)
	{
		//Get the chunk name and the chunk bytesize
		fread(&charBuffer, sizeof(char) * 4, 1, pFile);
		fread(&chunkContentSize, sizeof(long), 1, pFile);

		//read the format and save it
		if (strncmp(charBuffer, "fmt ", 4) == 0)
		{
			//check for the smallest value
			auto size = min(sizeof(WAVEFORMATEX), chunkContentSize);

			fread(&m_Format, size, 1, pFile);

			if (m_Format.wFormatTag != 1)
			{
				std::cout << "Wrong fmt" << std::endl;
				return false;
			}
		}
		//Read the actual sound data
		else if (strncmp(charBuffer, "data", 4) == 0)
		{
			m_AudioData = new char[chunkContentSize];
			m_AudioBufferByteSize = chunkContentSize;
			fread(m_AudioData, chunkContentSize, 1, pFile);
		}
		//Skip useless informations
		else
		{
			fseek(pFile, chunkContentSize, SEEK_CUR);
		}
	}

	fclose(pFile);
	return true;
}

WAVEFORMATEX triebWerk::CSoundSource::GetSoundFormat() const
{
	return m_Format;
}

unsigned long triebWerk::CSoundSource::GetDataSize() const
{
	return m_AudioBufferByteSize;
}

void triebWerk::CSoundSource::SetVolume(const float a_Volume)
{
	m_Volume = a_Volume;
}

float triebWerk::CSoundSource::GetVolume() const
{
	return m_Volume;
}

char * triebWerk::CSoundSource::GetRawSoundData() const
{
	return m_AudioData;
}
