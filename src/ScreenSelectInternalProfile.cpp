#include "ScreenSelectInternalProfile.h"
#include "Preference.h"
#include "PrefsManager.h"
#include "MemoryCardManager.h"

Preference<bool> s_bInternalProfiles(true);

REGISTER_SCREEN_CLASS( ScreenSelectInternalProfile );
ScreenSelectInternalProfile::ScreenSelectInternalProfile( CString sName )
{
	LOG->Trace( "ScreenSelectInternalProfile::ScreenSelectInternalProfile" );
}

void ScreenSelectInternalProfile::Init()
{
	ScreenOptionsMaster::Init();

	// populate player internal profiles vector
	FOREACH_HumanPlayer(p)
	{
		if ( MEMCARDMAN->GetCardState(pn) == MEMORY_CARD_STATE_READY )
		{
			if ( !MEMCARDMAN->MountCard(pn) )
				continue;

			CString sInternalProfilesPath = MEM_CARD_MOUNT_POINT[pn] + INTERNAL_PROFILFES_DIR;
			CStringArray sProfileNames;
			GetDirListing( sInternalProfilesPath+"/*", sProfileNames, true, false );
			for(unsigned i = 0; i < sProfileNames.size(); i++)
			{	
				// TODO: verification
				m_mInternalProfileList[pn].push_back(sProfileNames[pn]);
			}

			MEMCARDMAN->UnmountCard(pn);
		}
	}
	;
}

void ScreenSelectInternalProfile::Input( const DeviceInput& DeviceI, const InputEventType type, const GameInput &GameI, const MenuInput &MenuI, const StyleInput &StyleI )
{

} 

void ScreenSelectInternalProfile::HandleScreenMessage( const ScreenMessage SM )
{

}
