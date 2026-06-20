import tweepy


bearer_token = "AAAAAAAAAAAAAAAAAAAAAGBm5gEAAAAA4dfVmtMusKIXH2D7UoNr8pjY3qo%3DdpIl6rtXVHxSNhUED5jjdVfm4fg9IJ3awVwP5sKTPhcso5Duwi"
client = tweepy.Client(bearer_token=bearer_token)

user = client.get_user(username="nasa")
user_id = user.data.id
print(user_id)