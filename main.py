# import emoji
# import ray

# @ray.remote
# def f():
#     return emoji.emojize(f'Python is :thumbs_up: {'yknow'}')
# print(ray.get([f.remote() for _ in range(1000)]))

import emoji
import ray

@ray.remote
def f() -> str:
    return emoji.emojize(f'Python is :thumbs_up: {"yknow"}')

#Initialize Ray
# Note: Check if Ray is *not* initialized before initializing.
if not ray.is_initialized():
    ray.init()

print(ray.get([f.remote() for _ in range(1000)]))