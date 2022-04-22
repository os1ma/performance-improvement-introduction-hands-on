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


if __name__ == '__main__':
    main()
