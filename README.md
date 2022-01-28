# lambda-terraform-templates

- 01-1_ffmpeg-lambda-layer
    - lambda layer include ffmpeg, ffprobe
- 01_2_test-ffmpeg-layer-function
    - lambda that utilize `ffmpeg-lambda-layer` lambda
- 02_fixed-ip-function
    - fixed ip lambda using VPC, NAT GateWay, Elastic IP, etc.

## how to deploy

1. install tfenv

tfutils/tfenv: Terraform version manager
https://github.com/tfutils/tfenv

2. install direnv

Set the environment `AWS_PROFILE`.
DirEnv is useful.

direnv/direnv: unclutter your .profile
https://github.com/direnv/direnv

Check the aws you use like the command below;

```check_aws.sh
aws s3 ls
```

3. edit the variable

Edit `backend.tf`&`aws.tf` (check the region)  and `hoge.tfvars` as you need.

4. run command below;

```deploy.sh
cd TARGET_DIR

# install target version terraform
tfenv install $(cat .terraform-version)

# remove existing tf dir
rm -rf ./.terraform

# init
terraform init -backend-config "bucket=YOUR_TFSTATE_BUCKET_NAME"

# check
terraform plan -var-file=hoge.tfvars

# deploy
terraform apply -var-file=hoge.tfvars -auto-approve

```

5. clean the output

```destroy.sh
terraform destroy -var-file=hoge.tfvars -auto-approve

```


## Refs

### ffmpeg
- [FFmpeg をカスタムレイヤーとして Lambda 上で動かしてみた \| DevelopersIO](https://dev.classmethod.jp/articles/ffmpeg-lambda-layer/)

### fixed IP VPC Lambda
- [Lambdaから固定IPアドレスでkintoneと連携する方法 \| キントマニア \| kintone活用ブログ](https://www.joyzo.co.jp/blog/2325)
- [Deploy AWS Lambda to VPC with Terraform](https://www.maxivanov.io/deploy-aws-lambda-to-vpc-with-terraform/)