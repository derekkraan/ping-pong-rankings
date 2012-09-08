module LoadRankingAlgorithm
  extend ActiveSupport::Concern

  def algorithm_config
    @@config ||= YAML.load_file("#{Rails.root}/config/ranking_algorithm.yml")
  end

  def ranking_algorithm
    ranking_algorithm = algorithm_config['algorithm'].constantize
  end

end
