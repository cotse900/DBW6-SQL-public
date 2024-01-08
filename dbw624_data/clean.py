import csv
import os
import argparse


def clean_text(text):
    text = text.replace(", Ontario", " in Ontario").replace(",", " and")
    return text


def get_gender_from_filename(file_name):
    if "_female_" in file_name:
        return "Female"
    elif "_male_" in file_name:
        return "Male"
    else:
        return None


def process_append_gender(input_file):
    file_name = os.path.basename(input_file)
    output_file = os.path.splitext(file_name)[0] + "_append" + os.path.splitext(file_name)[1]
    gender = get_gender_from_filename(file_name)

    with open(input_file, 'r', newline='', encoding='utf-8-sig') as csv_in, open(output_file, 'w', newline='',
                                                                                 encoding='utf-8-sig') as csv_out:
        reader = csv.reader(csv_in)
        writer = csv.writer(csv_out)

        header = next(reader)
        header = ['Year', 'Name', 'Frequency', 'Gender']
        writer.writerow(header)

        for _ in range(1):
            next(reader)

        for row in reader:

            if all(field.strip() for field in row):
                row.append(gender)
                writer.writerow(row)

    print(f"Gender appended to baby names and saved to {output_file}")


def process_extract_life_expectancy(input_file):
    file_name = os.path.basename(input_file)
    output_file = os.path.splitext(file_name)[0] + "_append" + os.path.splitext(file_name)[1]
    gender = get_gender_from_filename(file_name)

    with open(input_file, 'r', newline='', encoding='utf-8-sig') as csv_in, open(output_file, 'w', newline='',
                                                                                 encoding='utf-8-sig') as csv_out:
        reader = csv.reader(csv_in)
        writer = csv.writer(csv_out)

        for _ in range(13):  # Ignore the first 13 lines
            next(reader)

        writer.writerow(['HealthUnit', 'BirthYear', 'Gender', 'LifeExpectancy'])  # Write the header

        for row in reader:
            if len(row) > 0 and "Ontario" in row[0]:
                health_unit = clean_text(row[0])
                LifeExpYear2014to2016 = row[-1]  # last row
                birth_year = 2018  # Birth year is 2018
                writer.writerow([health_unit, birth_year, gender, LifeExpYear2014to2016])

    print(f"Gender appended and life expectancy data extracted and saved to {output_file}")


def process_extract_population(input_file):
    file_name = os.path.basename(input_file)
    output_file = os.path.splitext(file_name)[0] + "_append" + os.path.splitext(file_name)[1]

    with open(input_file, 'r', newline='', encoding='utf-8-sig') as csv_in, open(output_file, 'w', newline='',
                                                                                 encoding='utf-8-sig') as csv_out:
        reader = csv.DictReader(csv_in)
        fieldnames = ['PopID', 'CityRegion', 'Population', 'Province', 'Year']
        writer = csv.DictWriter(csv_out, fieldnames=fieldnames)
        writer.writeheader()

        for row in reader:
            if row['Province or territory'] == 'Ontario':
                row['CityRegion'] = row['Geographic name'].replace(',', ' and')

                writer.writerow({
                    'PopID': row['Geographic code'],
                    'CityRegion': row['CityRegion'],
                    'Population': row['Population, 2016'],
                    'Province': 'Ontario',
                    'Year': 2016
                })

    print(f"Gender appended and 2016 population data for Ontario extracted to {output_file}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Combined ETL Script")
    parser.add_argument("input_file", help="Input CSV file")
    args = parser.parse_args()

    if "baby_names" in args.input_file:
        process_append_gender(args.input_file)
    elif "lifeexp" in args.input_file:
        process_extract_life_expectancy(args.input_file)
    elif "population" in args.input_file:
        process_extract_population(args.input_file)
