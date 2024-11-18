 
from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import FileResponse
import shutil
import os
from .services.voice_cloner import VoiceCloner
from .models.schemas import VoiceCloneResponse

app = FastAPI(title="Voice Cloning API")

# Initialize the voice cloner service
voice_cloner = VoiceCloner()

@app.post("/clone-voice", response_model=VoiceCloneResponse)
async def clone_voice(
    text: str = Form(...),
    language: str = Form(default="en"),
    reference_audio: UploadFile = File(...)
):
    try:
        # Save the uploaded audio file
        input_path = f"uploads/{reference_audio.filename}"
        os.makedirs("uploads", exist_ok=True)
        
        with open(input_path, "wb") as buffer:
            shutil.copyfileobj(reference_audio.file, buffer)
        
        # Generate the cloned voice
        output_path = await voice_cloner.clone_voice(
            text=text,
            reference_audio_path=input_path,
            language=language
        )
        
        # Clean up the input file
        os.remove(input_path)
        
        return VoiceCloneResponse(
            message="Voice cloned successfully",
            audio_path=output_path
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/download/{filename}")
async def download_audio(filename: str):
    file_path = f"output/{filename}"
    if os.path.exists(file_path):
        return FileResponse(file_path)
    raise HTTPException(status_code=404, detail="File not found")