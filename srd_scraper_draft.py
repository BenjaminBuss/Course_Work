# -*- coding: utf-8 -*-
"""
Created on Tue Mar 24 11:19:00 2020

@author: benjaminbuss
"""

# Import scrapy
import scrapy
# Import the CrawlerProcess
from scrapy.crawler import CrawlerProcess
# Import pandas 
import pandas as pd
# Import re
import re


base_url = 'https://5thsrd.org/gamemaster_rules/monster_indexes/monsters_by_name/'

# Create the Spider class
class MonsterNames(scrapy.Spider):
  name = 'monsternames'
  # start_requests method
  def start_requests( self ):
    yield scrapy.Request(url = base_url, callback = self.parse)
      
  def parse(self, response):
    # Initial scrape to get monster names and links
    monster_links = response.xpath('/html/body/div[2]/div[2]//p/a/@href').extract()
    #monster_name = response.xpath('//a[contains(@href,"/gamemaster_rules/monsters/")]/text()').extract()
    links_to_follow = monster_links
    
    #for monster_name, monster_links in zip( monster_name, monster_links ):
    #    monster_dict[monster_name] = monster_links
        
    for url in links_to_follow:
        yield response.follow(url = url, callback = self.parse_pages)
        
  def parse_pages(self, response):
    # Second round of parsing monster stats
    name  = response.xpath('/html/body/div[2]/div[2]/h1/text()').get()
    blurb = response.xpath('/html/body/div[2]/div[2]/p[1]/en/text()').get()
    ahpsp = response.xpath('/html/body/div[2]/div[2]/p[2]/text()[preceding-sibling::strong]').getall()
    stre  = response.xpath('/html/body/div[2]/div[2]/table/tbody/tr/td[1]/text()').get()
    dext  = response.xpath('/html/body/div[2]/div[2]/table/tbody/tr/td[2]/text()').get()
    cons  = response.xpath('/html/body/div[2]/div[2]/table/tbody/tr/td[3]/text()').get()
    inte  = response.xpath('/html/body/div[2]/div[2]/table/tbody/tr/td[4]/text()').get()
    wisd  = response.xpath('/html/body/div[2]/div[2]/table/tbody/tr/td[5]/text()').get()
    char  = response.xpath('/html/body/div[2]/div[2]/table/tbody/tr/td[6]/text()').get()
    save  = response.xpath('/html/body/div[2]/div[2]/p[3]/text()').get()
    misc  = response.xpath('/html/body/div[2]/div[2]/p[3]').get()
    actio = response.xpath('/html/body/div[2]/div[2]/p[4]').get()
    legac = response.xpath('/html/body/div[2]/div[2]/p[5]').get() 
        
    armor = ahpsp[0]
    hp    = ahpsp[2]
    speed = ahpsp[4]
    
    array = {'Name':name, 'Blurb':blurb,'AC': armor, 'HP':hp, 'Speed':speed, 
                           'STR':stre, 'DEX':dext, 'CON':cons, 'INT':inte, 'WIS':wisd, 'CHA':char, 
                           'Save':save, 'Misc':misc, 'Action':actio, 'Leg':legac}
    
    colnames = ('Name', 'Blurb', 'AC', 'HP', 'Speed', 'STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA', 
                'Save', 'Misc', 'Action', 'Leg')
    
    monster = pd.DataFrame(array, columns = colnames, index = [0])
    
    monster_dict[name] = monster
    
# Initialize the dictionary **outside** of the Spider class
monster_dict = dict()

# Run the Spider
process = CrawlerProcess()
process.crawl(MonsterNames)
process.start()


print(monster_dict['Ancient Gold Dragon'])

#print(monster_dict.keys())

print(len(monster_dict))


"""
for i in all the monsters:
    temp = this one
    
    if X in temp: 
        select that as resistances
        
        
    

"""
possible_attributes = ("Saving Throws", "Skills", "Damage Immunities", "Damage Resistances", "Damage Vulnerabilities",
                       "Condition Immunities", "Senses", "Languages", "Challenge")

end = '<strong>'
### Additional for loop to loop through all monsters goes here.
temp = monster_dict['Ancient Gold Dragon']

temp = temp['Misc'][0]

for bute in possible_attributes:
    
    if bute in temp:
        print(bute)
        print(temp[temp.find(bute)+len(bute):temp.rfind(end)])
        print()
        print()
        
        
print(temp)


###



