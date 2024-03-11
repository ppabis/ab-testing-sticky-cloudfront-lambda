Lambda@Edge - A/B testing origins but sticking for active users
================================================================
The task is: we have a CloudFront distribution and two application versions. We
want to direct some of the traffic to the new version for testing. However, we
want to stick the users who are currently using the old version to keep using it
so that they can finish their business. Implement it using Lambda@Edge.

So we have a sample app in Python with FastAPI. It generates cookies for the
session and keeps the parameters for the session in a DynamoDB Global Table.

The table is then looked up by a Lambda@Edge function on origin request event
from CloudFront. It checks if the session cookie is given and if it is stored in
the table. If not, we roll the two sided dice and direct user to the random
origin. If session is found and it is valid, we direct user to their last used
version.

Read more here:
- https://pabis.eu/blog/2024-03-11-Lambda-Edge-Select-Test-Origin-Stick-To-Old.html
- Dev.to: https://dev.to/aws-builders/lambdaedge-select-test-origin-or-stick-to-the-old-563h