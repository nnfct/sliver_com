from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI(title="So-Momeet API", version="0.1.0")

@app.get("/health")
async def health():
    return JSONResponse({"status": "ok"})

# TODO: /auth/me, users/profiles/tags, groups/posts/comments

def run():
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
