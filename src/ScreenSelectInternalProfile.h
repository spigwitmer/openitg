#include "global.h"
#include <vector>
#include <map>
#include "Screen.h"

#define INTERNAL_PROFILFES_DIR "/profiles"

class ScreenSelectInternalProfile : public ScreenOptionsMaster
{
public:
	ScreenSelectInternalProfile( CString sName );
	virtual void Init();

	virtual void Input( const DeviceInput& DeviceI, const InputEventType type, const GameInput &GameI, const MenuInput &MenuI, const StyleInput &StyleI );
	virtual void HandleScreenMessage( const ScreenMessage SM );

private:
	map<PlayerNumber, vector<CString> > m_mInternalProfileList;
};
