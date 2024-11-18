 
import torch
from TTS.api import TTS
import os

class VoiceCloner:
    def __init__(self):
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        print(f"Using device: {self.device}")
        
        self.tts = TTS(model_name="tts_models/multilingual/multi-dataset/your_tts",
                      progress_bar=True).to(self.device)

    async def clone_voice(self, text: str, reference_audio_path: str, language: str = "en") -> str:
        try:
            output_dir = "output"
            os.makedirs(output_dir, exist_ok=True)
            
            output_path = os.path.join(output_dir, "generated_speech.wav")
            
            self.tts.tts_to_file(
                text=text,
                speaker_wav=reference_audio_path,
                language=language,
                file_path=output_path
            )
            
            return output_path
            
        except Exception as e:
            raise Exception(f"Voice cloning failed: {str(e)}")