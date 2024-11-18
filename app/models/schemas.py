 
from pydantic import BaseModel

class VoiceCloneRequest(BaseModel):
    text: str
    language: str = "en"

class VoiceCloneResponse(BaseModel):
    message: str
    audio_path: str