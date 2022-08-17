require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  
  RSpec.describe API do
  include Rack::Test::Methods

  def app
    API.new(ledger: ledger)
  end
#let definition
  let(:ledger) { instance_double('ExpenseTracker::Ledger') }
  let(:expense) { { 'some' => 'data' } }

    describe 'POST /expenses' do
      
        context 'when the expense is successfully recorded' do
          let(:expense) { { 'some' => 'data'} }
          #hook
          before do
            allow(ledger).to receive(:record).with(expense).and_return(RecordResult.new(true, 417, nil))
          end

          it 'return the expense id' do
            expense = { 'some' => 'data' }
            # allow(ledger).to receive(:record).with(expense).and_return(RecordResult.new(true, 417, nil)) => Refactoring
            post '/expenses', JSON.generate(expense)

            parsed = JSON.parse(last_response.body)
            expect(parsed).to include('expense_id' => 417)
          end

          it 'responds with a 200 (OK)' do
            expense = { 'some' => 'data' }
            # allow(ledger).to receive(:record).with(expense).and_return(RecordResult.new(true, 417, nil)) => Refactoring
            post '/expenses', JSON.generate(expense)
            expect(last_response.status).to eq(200)
          end
        end

        context 'when the expense fails validation' do
          let(:expense) { {'some' => 'data'} }

          before do
            allow(ledger).to receive(:record).with(expense).and_return(RecordResult.new(false, 417, 'Expense incomplete'))
          end

          it 'returns an error message' do 
            post '/expenses', JSON.generate(expense)

            parsed = JSON.parse(last_response.body)
            expect(parsed).to include('error' => 'Expense incomplete')
          end

          it 'response with a 422 (Unprocessable entity)' do 
            post '/expenses', JSON.generate(expense)
            expect(last_response.status).to eq(422)
          end
        end  
    end
  end
#helper method
  def parsed_last_response
    JSON.parse(last_response.body)
  end
end
