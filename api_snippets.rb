class API < Sinatra::Base
  def initialize(ledger:)
    @ledger = Ledger.new
    super() #rest of initialization from Sinatra
  end
end

# Later, caller do this:
app = API.new(ledger: Ledger.new)
