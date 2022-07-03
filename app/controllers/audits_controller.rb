# frozen_string_literal: true

class AuditsController < AuthenticatedController
  def index
    @audits = Audit.all.order(id: :desc).limit(10)

    render action: "index", layout: false
  end
end
