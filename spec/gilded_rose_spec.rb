# frozen_string_literal: true

require './app/gilded_rose'

RSpec.describe GildedRose do
  describe '#update_quality' do
    context 'when is normal items' do
      it 'degrades in quality twice as fast when sell by date has passed' do
        items = [Item.new('foo', 0, 20)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('foo, -1, 18')
      end

      it 'does not have quality of negative value' do
        items = [Item.new('foo', 0, 0)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('foo, -1, 0')
      end
    end

    context 'when item is Aged Brie' do
      it 'increases in quality for Aged Brie' do
        items = [Item.new('Aged Brie', 1, 0)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Aged Brie, 0, 1')
      end

      it 'has capped the quality at 50 for Aged Brie' do
        items = [Item.new('Aged Brie', 1, 50)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Aged Brie, 0, 50')
      end

      it 'increases in quality by 2 when sell in is negative' do
        items = [Item.new('Aged Brie', -1, 0)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Aged Brie, -2, 2')
      end

      it 'does not increases in quality when sell in is negative and quality is 50' do
        items = [Item.new('Aged Brie', -1, 50)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Aged Brie, -2, 50')
      end
    end

    context 'when item is Sulfuras, Hand of Ragnaros' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 15, 20)]
      it 'does not decrease in quality and sell-in' do
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Sulfuras, Hand of Ragnaros, 15, 20')
      end
    end

    context 'when item is Backstage passes to a TAFKAL80ETC concert' do
      it 'increase quality when sell in is more than 11 and quality is 49' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 12, 49)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Backstage passes to a TAFKAL80ETC concert, 11, 50')
      end

      it 'increases quality by 2 when sell-in is 10 days or less' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 20)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Backstage passes to a TAFKAL80ETC concert, 9, 22')
      end

      it 'increases quality by 3 when sell-in is 10 days or less' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 20)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Backstage passes to a TAFKAL80ETC concert, 4, 23')
      end

      it 'has quality 0 after the concert' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', -1, 20)]
        described_class.new(items).update_quality
        expect(items[0].to_s).to eq('Backstage passes to a TAFKAL80ETC concert, -2, 0')
      end
    end
  end
end
