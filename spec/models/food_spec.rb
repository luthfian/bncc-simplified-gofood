require 'rails_helper'

describe Food do
  it "has a valid factory" do
    expect(FactoryGirl.build(:food)).to be_valid
  end

  it "is valid with a name and description" do
    expect(FactoryGirl.build(:food)).to be_valid
  end

  describe "invalid without name or description" do
    before :each do
      @food = FactoryGirl.build(:food, name: nil, description: nil)
    end
    
    it "is invalid without name" do
      @food.valid?
      expect(@food.errors[:name]).to include("can't be blank")
    end

    it "is invalid without description" do
      @food.valid?
      expect(@food.errors[:description]).to include("can't be blank")
    end
  end

  it "is invalid with a duplicate name" do
    food1 = FactoryGirl.create(:food, name: "Nasi Uduk")
    food2 = FactoryGirl.build(:food, name: "Nasi Uduk")

    food2.valid?
    expect(food2.errors[:name]).to include("has already been taken")
  end

  describe "filter name by letter" do
    before :each do
      @food1 = Food.create(
        name: "Nasi Uduk",
        description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
        price: 10000.0
      )

      @food2 = Food.create(
        name: "Kerak Telor",
        description: "Betawi traditional spicy omelette made from glutinous rice cooked with egg and served with serundeng.",
        price: 8000.0
      )

      @food3 = Food.create(
        name: "Nasi Semur Jengkol",
        description: "Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.",
        price: 8000.0
      )
    end

    context "with matching letters" do
      it "returns a sorted array of results that match" do
        expect(Food.by_letter("N")).to eq([@food3, @food1])
      end
    end

    context "with non-matching letters" do
      it "omits results that do not match" do
        expect(Food.by_letter("N")).not_to include(@food2)
      end
    end
  end

  it "is valid with numeric price greater or equal to 0.01" do
    food = Food.new(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 0.01
    )

    expect(food).to be_valid
  end

  it "is invalid with non numeric price" do
    food = Food.new(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: "sepuluh ribu"
    )
    food.valid?

    expect(food.errors[:price]).to include("is not a number")
  end

  it "is invalid with numeric price less than 0.01" do
    food = Food.new(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: -1000
    )
    food.valid?

    expect(food.errors[:price]).to include("must be greater than or equal to 0.01")
  end

  it "is valid with image_url ending with '.gif', '.jpg', or '.png'" do
    food = Food.new(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      image_url: "Nasi Uduk.jpg",
      price: 0.01
    )
    food.valid?

    expect(food).to be_valid
  end

  it "is invalid with image_url ending not with '.gif', '.jpg', or '.png'" do
    food = Food.new(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      image_url: "Nasi Uduk.csv",
      price: 0.01
    )
    food.valid?

    expect(food.errors[:image_url]).to include("must be a URL for GIF, JPG or PNG image.")
  end
end