import asyncio

import requests

MIN_POST_ID = 1
MAX_POST_ID = 100


def main():
    total_like_count = 0
    for post_id in range(MIN_POST_ID, MAX_POST_ID + 1):
        response = requests.get(f'http://localhost:3000/api/posts/{post_id}')
        response_body = response.json()
        total_like_count += response_body['likeCount']
    return total_like_count


async def get_post(post_id):
    loop = asyncio.get_event_loop()
    response = await loop.run_in_executor(None, requests.get, f'http://localhost:3000/api/posts/{post_id}')
    return response.json()


def fixed():
    coroutines = []
    for post_id in range(MIN_POST_ID, MAX_POST_ID + 1):
        coroutine = get_post(post_id)
        coroutines.append(coroutine)

    loop = asyncio.get_event_loop()
    gather = asyncio.gather(*coroutines)
    loop.run_until_complete(gather)
    response_bodies = loop.run_until_complete(gather)

    total_like_count = 0
    for response_body in response_bodies:
        total_like_count += response_body['likeCount']
    return total_like_count


if __name__ == '__main__':
    main()
