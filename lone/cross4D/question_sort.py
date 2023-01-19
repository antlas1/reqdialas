import csv
import os
import sys
import jinja2

skipped = []
database = []
linepos = 0
freq = [0] * 50 #сразу на N значений
min_word_size = 3
max_word_size = 15
with open('questions_unsorted.csv', newline='') as questions_csv_file:
        csvreader = csv.reader(questions_csv_file, delimiter=';', quoting=csv.QUOTE_NONE)
        for row in csvreader:
            linepos = linepos + 1
            question = row[0]
            answer = row[1]
            if answer.isalpha():
                anslen = len(answer)
                if anslen >= min_word_size and anslen <= max_word_size:
                    database.append((answer, question))
                else:
                    skipped.append((linepos, answer, question))
                freq[anslen] = freq[anslen] + 1
            else:
                skipped.append((linepos, answer, question))

print("Total base: {}, skipped len: {}".format(len(database), len(skipped)))
print("Freq word len:")
print(*freq, sep = ", ")
with open("skipped.txt",mode="w", encoding='utf-8') as fout:
    for skip in skipped:
        fout.write("{}: `{}` Q: {}\n".format(skip[0],skip[1],skip[2]))

with open('questions.csv', 'w', newline='', encoding='utf-8') as csv_file:
    writer = csv.writer(csv_file, delimiter=';')
    for word_ques in database:
        writer.writerow(word_ques)
environment = jinja2.Environment()
jinja_cpp_template="""
#include <string>
#include <vector>
//in header use export std::vector<std::pair<std::string,std::string> > ans_question_database;
std::vector<std::pair<std::string,std::string> > ans_question_database = {
{% for item in database %}
{ "{{ item[0] }}", "{{ item[1]|replace('"', "'") }}" } {{ ", " if not loop.last else "" }} {% endfor %}
};
"""
template = environment.from_string(jinja_cpp_template)
with open("questions.cpp",mode="w", encoding='utf-8') as fout:
    fout.write(template.render(database=database))
print("OK!")