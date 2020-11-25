require 'Date'

class Travel_plan
  attr_reader :name, :price, :id

  @@count = 0
  def initialize(**travel_plan_params)
    @name = travel_plan_params[:name]
    @price = travel_plan_params[:price]
    @id = @@count += 1
  end

end

class Travel_agency
  attr_reader :travel_plan

  def initialize(travel_plan_params)
    @travel_plan = []
    travel_plan_params.each do |param|
      @travel_plan << Travel_plan.new(param)
    end
  end

  def disp_plan
    puts "旅行プランを洗濯してください"

    @travel_plan.each do |param, id|
      puts "#{param.id}.#{param.name}(¥#{param.price.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}円)"
    end
  
  end

  def calculate_charges(chosen_plan, number_of_people)
    @total_price = chosen_plan.price * number_of_people
    
    date_check
    departure_day_check
    
    if number_of_people >= 5
      puts "5人以上なので10%割引となります"
      @total_price *= 0.9
    end
    puts "合計金額: ¥#{@total_price.floor.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}円"

  end

  def date_check
    @today = Date.today
    
    # 今日の日付が5のつく日か調べる
    if date_check = @today.to_s.include?("5")
      puts "今日は#{@today.strftime("%Y年%m月%d日")}です。5がつく日は10%割引となります。"
      @total_price *= 0.9
    end
    #puts "合計金額: ¥#{@total_price.floor.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}円"
    @total_price

  end

  def departure_day_check
    puts "出発日を入力して下さい"

    while true do
      print "年 > "
      date_y = gets.to_i
      print "月 > "
      date_m = gets.to_i
      print "日 > "
      date_d = gets.to_i

      begin
        # 入力された出発日が有効か調べる
        departure_day = Date.parse("#{date_y}/#{date_m}/#{date_d}")
        break if departure_day > @today
        puts "明日以降の日付を入力してください"
      rescue
        puts "無効な日付です"
      end
      
    end

    puts "#{departure_day.strftime("%Y年%m月%d日")}ですね"

    after_day = @today.next_day(14)

    # 出発日が今日から14日後かどうかの処理
    if after_day <= departure_day
      @total_price *= 0.9
      puts "14日前までの予約は10%割引です"
    end
    #puts "合計金額: ¥#{@total_price.floor.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}円"

    @total_price
  end
end

class User
  attr_reader :chosen_plan, :number_of_people
  
  def select_plan(travel_plan)
    while true do
      print "プランを選択 > "
      select_plan = gets.to_i
      @chosen_plan = travel_plan.find { |plan| plan.id == select_plan}
      
      break if (travel_plan.first.id..travel_plan.last.id) === select_plan
      puts "#{travel_plan.first.id}から#{travel_plan.last.id}の中から選んでください。"
    end

    travel_plan[select_plan - 1] 
  end

  def how_many
    puts "#{@chosen_plan.name}ですね、何人で行きますか?"

    while true do
      print "人数を入力 > "
      @number_of_people = gets.to_i
      break if @number_of_people >= 1
      puts "１人以上を入力してください"
    end
    @number_of_people
  end

end

travel_plan_params = [
  { name: "沖縄旅行", price: 10000 },
  { name: "北海道旅行", price: 20000 },
  { name: "九州旅行", price: 15000 }
]

travel_agency = Travel_agency.new(travel_plan_params)
travel_agency.disp_plan
user = User.new
user.select_plan(travel_agency.travel_plan)
user.how_many
travel_agency.calculate_charges(user.chosen_plan, user.number_of_people)