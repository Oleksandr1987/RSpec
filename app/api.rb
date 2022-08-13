require 'sinatra/base'
require 'json'

module ExpenseTracker
  class API < Sinatra::Base
    post '/expenses' do 
        status 404
        
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)  
      JSON.generate('expense_id' => result.expense_id)
    end
      
    get '/expenses/:date' do
        JSON.generate([])  
    end

    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

  end
end
