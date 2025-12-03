import asyncio
import httpx

from api import cat_api_endpoint_url

# Configuration
NUM_OF_REQUESTS = 100 + 1


async def hit_panic_endpoint(hits=NUM_OF_REQUESTS):
    async with httpx.AsyncClient() as client:
        for _ in range(hits):
            await client.get(cat_api_endpoint_url("panic"))


if __name__ == "__main__":
    asyncio.run(hit_panic_endpoint())
