bash 'install_and_configure_github_runner' do
    code <<-EOH
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo apt-get install -y jq

    registration_url="https://api.github.com/repos/jubuitrago/Tunefy/actions/runners/registration-token"
    echo "Requesting registration URL at '${registration_url}'"
    payload=$(curl -sX POST -H "Authorization: token GITHUB_PERSONAL_TOKEN" ${registration_url})
    export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)

    cd $HOME
    mkdir actions-runner
    cd $HOME/actions-runner
    curl -o actions-runner-linux-x64-2.314.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-linux-x64-2.314.1.tar.gz
    tar xzf ./actions-runner-linux-x64-2.314.1.tar.gz

    pwd

    ./config.sh --name Runner --token ${RUNNER_TOKEN} -- labels my-runner --url https://github.com/jubuitrago/Tunefy --work "/work" --unattended

    sudo ./svc.sh install
    sudo ./svc.sh start

    EOH
  end
  