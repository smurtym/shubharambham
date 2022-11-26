from fastapi import FastAPI
from routers import cities, panchang, grahana
import uvicorn


app = FastAPI()

app.include_router(cities.router)
app.include_router(panchang.router)
app.include_router(grahana.router)

@app.get("/")
async def root():
    return {"message": "This is root API. Nothing here"}

if __name__ == '__main__':
    uvicorn.run("main:app", port=80, reload=True) #Change to actual port number as per nginx.conf file