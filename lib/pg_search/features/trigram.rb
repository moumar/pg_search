module PgSearch
  module Features
    class Trigram < Feature
      def conditions
        similarity = options[:similarity] || 0.3
        Arel::Nodes::Grouping.new(
          Arel::Nodes::InfixOperation.new(">",
            Arel::Nodes::NamedFunction.new("similarity", [normalized_document, normalize(query)]) , similarity)
        )
      end

      def rank
        Arel::Nodes::Grouping.new(
          Arel::Nodes::NamedFunction.new(
            "similarity",
            [
              normalized_document,
              normalize(query)
            ]
          )
        )
      end

      private

      def normalized_document
        Arel::Nodes::Grouping.new(normalize(Arel.sql(document)))
      end
    end
  end
end
