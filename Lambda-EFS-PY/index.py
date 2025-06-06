# # AwsCliLayer bundles the AWS CLI in a lambda layer
# from aws_cdk.lambda_layer_awscli import AwsCliLayer

# # fn: lambda.Function

# fn.add_layers(AwsCliLayer(self, "AwsCliLayer"))

# # index.py
# import boto3
# import os
# import subprocess
# import datetime

# s3_bucket = os.environ['S3_BUCKET']
# efs_mount_point = '/mnt/efs'

# def handler(event, context):
#     today = datetime.datetime.now().strftime('%Y-%m-%d')
#     s3_prefix = f"efs-backup/{today}/"

#     try:
#         print(f"Backing up EFS contents from {efs_mount_point} to s3://{s3_bucket}/{s3_prefix}")
        
#         subprocess.run([
#             "/opt/aws-cli/bin/aws", "s3", "cp", efs_mount_point,
#             f"s3://{s3_bucket}/{s3_prefix}",
#             "--recursive"
#         ], check=True)

#         print("Backup complete.")
#     except subprocess.CalledProcessError as e:
#         print(f"Backup failed: {e}")
