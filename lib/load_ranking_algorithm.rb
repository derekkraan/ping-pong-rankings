module LoadRankingAlgorithm
  extend ActiveSupport::Concern

  def algorithm_config
    @@config ||= YAML.load_file("#{Rails.root}/config/ranking_algorithm.yml")
    @@config
  end

  def ranking_algorithm
    algorithm_config['algorithm'].constantize
  end

end
