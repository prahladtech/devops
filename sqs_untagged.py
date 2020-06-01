import boto3
client = boto3.client('sqs')
tagged = 0
untagged = 0
queues = client.list_queues()
for queue_url in queues['QueueUrls']:
	tags = client.list_queue_tags(QueueUrl=queue_url)
	tt = tags.get('Tags', None)
	if tt:
		if tt.get('ProductDomain', ''):
			tagged += 1
		else:
			untagged += 1
			print(queue_url[56:], tt, sep=',,,')
	else:
		untagged += 1
		print(queue_url[56:], '[]', sep=',,,')
print('tagged', tagged)
print('untagged', untagged)
