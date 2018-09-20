require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/kubernetes_deploy'

module D2HUB
  describe GetKubernetesDeploys do
    subject { GetKubernetesDeploys }

    let(:build_tag_id) { 1 }
    let(:kubernetes_deploy_id) { 1 }
    let(:params) do {
      kubernetes_url:  'test_url',
      kubernetes_kubeconfig:  'test_kubeconfig',
      kubernetes_yaml_path:  'test_yamlpath',
      env_vars:  'ENV01=VAL01',
    }
    end

    let(:repo_params) do
      {
          org_name: 'test_user',
          repo_name: 'test_repo',
          description: 'test repository'
      }
    end
    let(:user_name) { 'test_user' }
    before do
      CreateUser.run user_name: user_name
      new_repo = CreateRepository.run repo_params
      new_repo.add_build_tag git_type: 'Branch',
                              git_branch_name: 'master',
                              dockerfile_location: '/',
                              docker_tag_name: 'latest',
                              use_regex: false,
                              dockerfile_name: 'Dockerfile',
                              dockerbuild_arg: ''
    end

    it 'should list kubernetes deploy' do
      (1..20).each do |num|
        CreateKubernetesDeploy.run build_tag_id: build_tag_id,
                                   kubernetes_url: params[:kubernetes_url],
                                   kubernetes_kubeconfig: params[:kubernetes_kubeconfig],
                                   kubernetes_yaml_path: params[:kubernetes_yaml_path],
                                   env_vars: params[:env_vars]
      end
      kubernetes_deploy = GetKubernetesDeploys.run build_tag_id: build_tag_id

      expect(kubernetes_deploy.length).to eq 20
    end
  end
end