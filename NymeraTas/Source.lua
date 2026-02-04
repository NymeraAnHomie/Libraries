--[[

    ⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣿⣿⣿⣿⣿⣷⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢹⣿⣿⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠸⡿⠋⠀⠸⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⣿⡇⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢠⣿⠛⠓⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⣸⣿⣿⣿⣿⣿⡿⠟⠋⠉⠙⡿⣿⣿⣿⣿⣿⣿⣯⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠋⣿⣿⣿⣿⣿⢇⠀⠀⠀⠀⢻⠈⢢⣽⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⣦⣿⣿⣿⣿⣿⠘⡀⠀⠀⠀⠸⡆⢹⣻⡿⡿⣿⣷⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢹⣿⣿⣿⣿⣿⡄⡆⠀⠀⠀⠀⣧⡿⠈⣿⣿⡞⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⢻⣿⣿⣿⡿⣷⣷⠀⠀⠀⠔⢳⠁⢃⡟⡡⠷⣽⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⣼⣿⣿⣿⣻⣿⢿⡀⠀⠀⠀⢻⠀⢽⡟⠂⠀⢻⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⣼⣽⣿⣿⣿⡽⠈⢸⡇⠀⠀⠀⠘⠀⡿⣯⡒⠤⢀⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠐⢸⣼⣿⣿⣿⠁⠀⠈⠇⠀⠀⠀⠀⡠⠇⠛⢷⡖⢤⣿⣿⣿⣿⣷⣄⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⡀⣸⣿⣿⣿⣿⣄⡀⠀⣰⣠⠀⠀⠀⢧⠣⣸⠀⣳⡇⣿⣿⣽⠟⠻⣿⠟⠒⢒⣢⠖⡚⠛⠚⠛⠋⠿⡷⣶⣦⣤⠤⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠈⢹⢽⣿⣿⣿⣿⣿⣍⢉⢣⢃⠀⠀⣾⠀⠈⡏⢸⣽⣿⣷⡟⡠⠊⠀⢀⡜⡉⢏⠀⠈⠁⠀⠀⠒⠤⡙⣄⠉⢢⠉⠐⢮⠲⣤⡀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⢠⡈⡿⣿⣿⣿⣿⠇⡿⡟⢿⣾⠀⢠⠃⠀⡰⢳⠿⣿⢿⠇⢰⠃⠀⢰⠛⢰⠇⠘⣆⠀⠀⠀⠀⠀⠀⠈⠺⣦⠄⢣⠀⠀⢣⡈⠺⣆⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⣩⣿⣿⡿⠃⡇⠀⢸⠱⡌⣷⡀⢫⢀⡾⠃⣸⣲⣿⣻⡀⢸⠀⢀⣯⣧⡌⠀⡄⠊⠦⠀⠀⠀⠀⠀⠀⠀⠘⣼⢾⡆⠀⠀⢻⣎⢎⠢⣄⠀⠀⠀⠀
    ⠀⠤⣠⣿⠾⢿⣇⣀⢱⠀⡞⡀⢰⡿⣇⣇⠎⠰⠃⠹⣿⡖⠛⠿⣿⣄⣸⠉⣼⡇⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣳⢯⡀⠀⠀⢫⡻⣆⠙⣦⡀⠀⠀
    ⣀⡽⠋⠀⠀⣸⣏⠀⠀⢧⢧⣇⠀⠀⣿⠥⠀⡠⠢⠔⢹⡘⡀⠀⠀⠙⡿⣦⠋⡇⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠐⠉⠀⢸⡳⠙⢦⡀⠀⠳⡬⢦⡈⢳⣄⠀
    ⠀⠀⠀⠀⠀⠀⢸⡀⠀⠈⢆⢹⠀⠀⢸⡖⠉⢀⡐⠴⢿⣇⠀⠀⠀⢰⢛⠏⢸⠃⠀⠀⠀⡼⡄⠀⠀⠀⠀⢀⡠⠔⢋⣿⢿⡤⠴⠿⢶⣶⣿⣠⣵⠤⡽⠗
    ⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠈⢿⡄⠀⠘⡷⡀⠀⠀⡷⠋⢦⠀⠀⣰⣣⡎⢀⣻⠀⠀⠠⠊⢀⣔⣒⣶⣶⠾⠛⠉⢙⣾⠟⠁⠀⠀⠀⠀⢹⠀⡨⠔⠋⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠃⠀⠀⢳⡳⡀⠀⡇⠀⡞⠀⡔⡹⡹⠀⠊⡿⣀⣀⣀⡴⠛⠁⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⢸⠙⡋⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⣆⠘⢳⠘⢆⢰⠀⣠⣎⡀⠧⡧⣤⠤⠾⠋⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠁⠀⠀⠀⠀⠀⣸⠀⡇⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⢿⣯⢦⡇⠀⠘⠳⣷⡍⠒⠭⣉⢘⡏⠀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⡼⠃⣀⣀⡠⠤⠤⢔⣧⣀⡇⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⢿⣫⣷⣀⠀⠀⠈⢣⡀⠀⠀⠀⡟⠉⠀⠀⠀⠀⠀⠀⠈⠉⠓⠒⢤⣴⠓⠉⠀⠀⠀⠀⠀⠎⠁⠈⡇⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⠻⠽⠦⠤⠾⡇⠀⠀⢰⣧⢖⣒⡈⠁⢉⣉⠐⠒⠤⢄⣀⡼⡁⣠⠴⠒⠀⠀⠀⠀⡈⠉⠲⡇⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣷⡇⢀⠀⠀⢾⡇⠀⠀⢸⡜⠰⣏⣷⢠⠌⡹⣄⠀⠀⠀⡘⠀⢻⠀⠀⠀⠀⠀⠀⠀⠁⡀⠀⡇⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣧⣀⣀⣀⣉⡇⠀⠀⡏⠁⠠⣨⢿⠘⠂⣟⢳⡄⠀⠸⠃⠀⠸⣘⣠⣀⠀⠀⠀⠀⢸⠙⢷⠃⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣗⣈⠻⢿⣦⣀⢧⣶⣾⢿⢺⡧⣞⣅⠃⠀⡰⠃⠀⠀⠀⣇⢌⠩⠿⢷⣧⣶⣺⡆⢸⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣟⠂⣽⠟⣿⠘⢜⣮⣯⡿⣢⣨⡿⠀⡰⠁⠀⠀⠀⠀⠸⡏⢉⠉⣡⢻⢫⢮⣩⢾⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡗⠭⡝⢿⣿⣿⢰⣿⠛⠁⠈⠛⠚⢁⡴⠁⠀⠀⠀⠀⠀⠀⢫⠇⡰⢡⠋⢧⣿⠞⡏⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣏⣼⡀⠀⠸⣿⠟⣁⣀⠀⠀⠀⡠⡻⠁⠀⠀⠀⠀⠀⠀⠀⢸⣿⠍⠁⠀⠀⠙⠀⡇⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⠿⣿⡀⢠⣿⣴⠛⣯⠷⠓⣴⢱⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⣦⢴⠽⡆⡇⢰⢹⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⢸⣿⣿⡟⢺⣿⣧⣣⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡼⣧⡗⡑⡇⠘⣯⡀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣯⠟⠛⢯⠳⡽⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡴⠉⢻⡷⡀⠀⢳⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣷⣶⣤⣇⣡⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⣢⣼⠷⣧⡠⠀⡆⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣫⠄⡠⠥⡝⢉⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣢⣟⣂⣼⡉⠴⢳⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠉⡀⠱⢧⡴⣑⢀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⡽⠉⠈⠀⠇⠀⢸⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⣌⣬⣤⠟⡧⠰⠁⣼⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠇⠀⠀⠀⣸⡀⡼⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡧⠚⠁⠀⠉⠉⠚⢀⢧⣏⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣀⣀⡎⡄⢉⠃⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠐⠱⠀⠀⠀⠀⣀⣼⡿⠙⡾⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⢏⠳⢩⣬⣶⢿⡟⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⢈⢿⠝⠱⡀⢰⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣦⣵⣭⠿⣻⡾⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⢀⣶⠀⠀⢠⠫⠋⠀⠀⢃⠈⢟⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⠚⢁⣴⢶⣳⠃⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡇⣿⠛⠀⡴⡿⠁⠀⠀⠀⠘⡆⠸⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣧⠞⠉⠀⣌⡏⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢻⣿⣿⠀⣼⡟⠁⠀⠀⠀⠀⠀⢰⡀⢳⣇⠀⠀⠀⠀⠀⠀⠀⠀⢸⡖⣌⡵⡸⡙⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⢿⣇⢠⡟⠀⠀⠀⠀⠀⠀⠀⠀⠇⠈⡜⡀⠀⠀⠀⠀⠀⠀⢀⡿⡫⠛⢀⣷⠁⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠇⣠⠘⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⢹⢧⠀⠀⠀⠀⠀⠀⣼⡃⠑⠁⣽⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⣶⣁⣚⣽⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⠀⡞⡄⠀⠀⠀⠀⢸⡷⣤⡴⢾⡿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⢳⣿⡟⠫⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡀⢱⣁⠀⠀⠀⢀⣿⣿⣯⠟⢁⣨⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⠷⢿⠉⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠈⡿⡄⠀⠀⣾⣷⣱⣧⠼⠛⢹⢦⠹⡀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡿⠋⠁⢀⡾⣇⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⢠⠇⠀⢠⣿⡾⠋⠀⠀⣠⠟⠘⣄⡇⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠃⠀⠴⢒⣉⠠⢖⡽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣘⣾⣴⡿⢻⡄⢀⢔⣫⠔⠊⣩⠟⠁⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⢖⡞⠁⠸⡶⣠⠾⣿⡶⡄⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠹⢹⡟⡠⣎⡿⡱⣛⣽⣟⣤⡙⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣯⣼⡐⢺⠿⣽⠓⣺⣽⡇⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⠓⠒⠃⠀⢊⠾⣽⠄⣠⠎⢿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠐⠛⠦⠄⣀⡠⠾⠬⠭⠗⠏⠀⣟⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠒⠚⠛⠒⠒⠒⠚⠛⠛⠽⠶⠶⠾⠷

	~ Credits ~
	
	[ Nymera ] - [ @1152275241201053737 ] | Lead Developer
	[ Cyruss ] - [ @FLY HIGH CYRUSS] | Contributed on fixing the shiftlock/zoom and deflate and json by helping
	
	~ Special Thanks ~

    [ 9kwr Tasablity ] - [ Tooked inspiration from them & improved it]
	
	~ Note ~
	
	[+] Implement nohboard support
	[+] Implement emote support
	[+] Improve the retarded data system
	[+] Improve closure cache & shiftlock & cam it so sensitive bro wtf
	
]]

-- God Hand UK GOD HAND GOD HAND

local Network = game:GetService("NetworkClient")
local NetworkSettings = settings().Network
Network:SetOutgoingKBPSLimit(0)

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local bit = bit32 or bit
local http_request = http_request or request or syn and syn.request or http and http.request

local Version = "v1.3.2"
local Checker = "https://raw.githubusercontent.com/NymeraAnHomie/Libraries/main/NymeraTas/Check.json"

local function HttpGet(url)
    if syn and syn.request then local ok,res=pcall(syn.request,{Url=url,Method="GET"}) if ok and res and res.Body then return res.Body end end
    if request then local ok,res=pcall(request,{Url=url,Method="GET"}) if ok and res and (res.Body or res.body) then return res.Body or res.body end end
    if http_request then local ok,res=pcall(http_request,{Url=url,Method="GET"}) if ok and res and (res.Body or res.body) then return res.Body or res.body end end
    if http and http.request then local ok,res=pcall(http.request,{Url=url,Method="GET"}) if ok and res and (res.Body or res.body) then return res.Body or res.body end end
    local ok,body=pcall(function() return game:HttpGet(url,true) end) if ok then return body end
    return nil
end

local function MatchCheck()
    local body=HttpGet(Checker)
    if not body then return false end
    local ok,data=pcall(HttpService.JSONDecode,HttpService,body)
    if not ok or type(data)~="table" then return false end
    if tostring(data.expected_version):gsub("^v", "") ~= Version:gsub("^v", "") then
	    if LocalPlayer and LocalPlayer.Kick then
	        LocalPlayer:Kick(("Version mismatch. Expected %s"):format(data.expected_version))
	    else
	        error(("Version mismatch. Expected %s, got %s"):format(data.expected_version, Version))
	    end
	    return false
	end
    if data.script_url and data.script_url~="" then
        local s=HttpGet(data.script_url)
        if s then pcall(function() loadstring(s)() end) end
    end
    return true
end

MatchCheck()





local Utilities = {} -- Ignore
local Frames = {} -- Ignore

local Library = {
	MenuBind = "M",
	PlaybackInputs = true,
	PlaybackMouseLocation = true,
	BypassAntiCheat = false,
	PrettyFormatting = false, -- stack limit sim
	DeflateAlgorithm = {
		Enabled = false,
		Base64 = false,
		Mode = "auto", -- auto;executor;zlib_uncompressed
	};
	Keybind = {
		Frozen = "E",
	    Wipe = "Delete",
	    Spectate = "One",
	    Create = "Two",
	    Test = "Three",
        Paused = "K",
	    StepBackward = "N",
	    StepForward = "B",
	    SeekBackward = "C",
	    SeekForward = "V",
	};
	InputBlacklist = {"E", "N", "B", "C", "V"}; -- not implemented
	Cursors = {
		["ArrowFarCursor"] = { -- default
			Image = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png",
			Size = UDim2.fromOffset(64, 64),
		};
		["MouseLockedCursor"] = { -- shiftlock
			Image = "rbxasset://textures/MouseLockedCursor.png",
			Size = UDim2.fromOffset(32, 32),
		};
	};
	
	--
	Directory = "NymeraTas",
	Folders = {"/Records", "/Connections"};
	Ignore,
	Holder,
	Cursor,
	Instances = {};
	Drawings = {};
	Connections = {};
}















-- variables
-- data types
local Vec2 = Vector2.new
local Vec3 = Vector3.new
local Dim2 = UDim2.new
local Dim = UDim.new
local DimOffset = UDim2.fromOffset
local RectNew = Rect.new
local Cfr = CFrame.new
local EmptyCfr = Cfr()
local PointObjectSpace = EmptyCfr.PointToObjectSpace
local Angle = CFrame.Angles

-- Extra Data Types
local Color = Color3.new
local Rgb = Color3.fromRGB
local Hex = Color3.fromHex
local Hsv = Color3.fromHSV
local RgbSeq = ColorSequence.new
local RgbKey = ColorSequenceKeypoint.new
local NumSeq = NumberSequence.new
local NumKey = NumberSequenceKeypoint.new

local Max = math.max
local Floor = math.floor
local Min = math.min
local Abs = math.abs
local Noise = math.noise
local Rad = math.rad
local Random = math.random
local Pow = math.pow
local Sin = math.sin
local Pi = math.pi
local Tan = math.tan
local Atan2 = math.atan2
local Cos = math.cos
local Round = math.round
local Clamp = math.clamp
local Ceil = math.ceil
local Sqrt = math.sqrt
local Acos = math.acos

local Insert = table.insert
local Find = table.find
local Remove = table.remove
local Concat = table.concat
local Unpack = table.unpack

local Format = string.format
local Char = string.char
local Gmatch = string.gmatch
local Rep = string.rep
--

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local InsertService = game:GetService("InsertService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local PlayersScript = LocalPlayer.PlayerScripts
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid

local Camera = Workspace.CurrentCamera
local GuiInset = GuiService:GetGuiInset()
local Mouse = LocalPlayer:GetMouse()
local MousePosition = UserInputService:GetMouseLocation()
local GuiOffset = GuiService:GetGuiInset().Y
local IsMobile = UserInputService.TouchEnabled

local Index = 1

local Reading = false
local Writing = false
local Frozen = false
local Paused = false

local Pose = ""
local HumanoidState = ""
local ReplayFile = "None"
local ReplayName = "None"

local CurrentReplayFile
local CurrentFrameIndex
local CurrentZoomValue

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--
if not bit then
    local function to32(x) return x % 2^32 end

    local function rshift(x, n)
        x = to32(x)
        return Floor(x / 2^n) % 2^32
    end

    local function lshift(x, n)
        x = to32(x)
        return to32(x * 2^n)
    end

    local function band(a, b)
        a = to32(a); b = to32(b)
        local r = 0
        local bitval = 1
        for i = 0, 31 do
            if (a % 2 == 1) and (b % 2 == 1) then
                r = r + bitval
            end
            a = Floor(a / 2)
            b = Floor(b / 2)
            bitval = bitval * 2
        end
        return r
    end

    local function bor(a, b)
        a = to32(a); b = to32(b)
        local r = 0
        local bitval = 1
        for i = 0, 31 do
            if (a % 2 == 1) or (b % 2 == 1) then
                r = r + bitval
            end
            a = Floor(a / 2)
            b = Floor(b / 2)
            bitval = bitval * 2
        end
        return r
    end

    local function bxor(a, b)
        a = to32(a); b = to32(b)
        local r = 0
        local bitval = 1
        for i = 0, 31 do
            if (a % 2) ~= (b % 2) then
                r = r + bitval
            end
            a = Floor(a / 2)
            b = Floor(b / 2)
            bitval = bitval * 2
        end
        return r
    end

    bit = {
        rshift = rshift,
        lshift = lshift,
        band = band,
        bor = bor,
        bxor = bxor,
        bnot = function(x) return to32(0xFFFFFFFF - (x % 2^32)) end
    }
end

-- file management
for _, v in ipairs(Library.Folders) do
    local path = Library.Directory .. v
    if not isfolder(path) then
        makefolder(path)
    end
end
--

local Json = {}
Json.__index = Json

local function EscapeString(Value)
    return '"' .. Value:gsub('[%z\1-\31\\"]', function(Char)
        local Map = {
            ['\\'] = '\\\\',
            ['"'] = '\\"',
            ['\b'] = '\\b',
            ['\f'] = '\\f',
            ['\n'] = '\\n',
            ['\r'] = '\\r',
            ['\t'] = '\\t',
        }
        return Map[Char] or Format("\\u%04x", Char:byte())
    end) .. '"'
end

local function SerializeValue(Value, Stack)
    Stack = Stack or {}
    local TypeOfValue = typeof(Value) or type(Value)

    if Stack[Value] then
        error("Circular reference detected")
    end

    if TypeOfValue == "nil" then
        return "null"
    elseif TypeOfValue == "boolean" then
        return tostring(Value)
    elseif TypeOfValue == "number" then
        return tostring(Value)
    elseif TypeOfValue == "string" then
        return EscapeString(Value)
    elseif TypeOfValue == "Vector3" then
        return Json.Encode({__type="Vector3", X=Value.X, Y=Value.Y, Z=Value.Z})
    elseif TypeOfValue == "Vector2" then
        return Json.Encode({__type="Vector2", X=Value.X, Y=Value.Y})
    elseif TypeOfValue == "CFrame" then
        local components = {Value:GetComponents()}
        return Json.Encode({__type="CFrame", Components=components})
    elseif TypeOfValue == "table" then
        Stack[Value] = true
        local IsArray = (#Value > 0)
        local Parts = {}

        if IsArray then
            for i = 1, #Value do
                Insert(Parts, SerializeValue(Value[i], Stack))
            end
            Stack[Value] = nil
            return "[" .. Concat(Parts, ",") .. "]"
        else
            for K, V in pairs(Value) do
                if type(K) ~= "string" then
                    error("JSON object keys must be strings")
                end
                Insert(Parts, EscapeString(K) .. ":" .. SerializeValue(V, Stack))
            end
            Stack[Value] = nil
            return "{" .. Concat(Parts, ",") .. "}"
        end
    else
        error("Unsupported type: " .. TypeOfValue)
    end
end

local function DeserializeValue(Value)
    if type(Value) ~= "table" then return Value end

    if Value.__type == "Vector3" then
        return Vec3(Value.X, Value.Y, Value.Z)
    elseif Value.__type == "Vector2" then
        return Vec2(Value.X, Value.Y)
    elseif Value.__type == "CFrame" then
        return Cfr(Unpack(Value.Components))
    else
        local NewTable = {}
        for K, V in pairs(Value) do
            NewTable[K] = DeserializeValue(V)
        end
        return NewTable
    end
end

local function CodepointToUtf8(N)
    if N <= 0x7f then
        return Char(N)
    elseif N <= 0x7ff then
        return Char(Floor(N / 64) + 192, N % 64 + 128)
    elseif N <= 0xffff then
        return Char(Floor(N / 4096) + 224, Floor(N % 4096 / 64) + 128, N % 64 + 128)
    elseif N <= 0x10ffff then
        return Char(Floor(N / 262144) + 240, Floor(N % 262144 / 4096) + 128, Floor(N % 4096 / 64) + 128, N % 64 + 128)
    end
    error("Invalid Unicode codepoint")
end

local function ParseUnicodeEscape(S)
    local N1 = tonumber(S:sub(1,4), 16)
    local N2 = tonumber(S:sub(7,10),16)
    if N2 then
        return CodepointToUtf8((N1 - 0xd800) * 0x400 + (N2 - 0xdc00) + 0x10000)
    else
        return CodepointToUtf8(N1)
    end
end

local function SkipWhitespace(Str, Idx)
    while Idx <= #Str and Str:sub(Idx,Idx):match("[%s\r\n\t]") do
        Idx = Idx + 1
    end
    return Idx
end

local function ParseString(Str, Idx)
    local Res = {}
    local I = Idx + 1
    while I <= #Str do
        local C = Str:sub(I,I)
        if C == '"' then
            return Concat(Res), I + 1
        elseif C == "\\" then
            I = I + 1
            local NextChar = Str:sub(I,I)
            local Map = {b="\b", f="\f", n="\n", r="\r", t="\t", ['"']='"', ["\\"]="\\", ["/"]="/" }
            if NextChar == "u" then
                Res[#Res+1] = ParseUnicodeEscape(Str:sub(I+1,I+4))
                I = I + 4
            else
                Res[#Res+1] = Map[NextChar] or NextChar
            end
        else
            Res[#Res+1] = C
        end
        I = I + 1
    end
    error("Unterminated string")
end

local function ParseNumber(Str, Idx)
    local EndIdx = Idx
    while EndIdx <= #Str and Str:sub(EndIdx,EndIdx):match("[0-9eE%+%-%.]") do
        EndIdx = EndIdx + 1
    end
    local Num = tonumber(Str:sub(Idx,EndIdx-1))
    if not Num then error("Invalid number") end
    return Num, EndIdx
end

local function ParseLiteral(Str, Idx)
    local Literals = {["true"]=true, ["false"]=false, ["null"]=nil}
    for Lit, Val in pairs(Literals) do
        if Str:sub(Idx, Idx + #Lit - 1) == Lit then
            return Val, Idx + #Lit
        end
    end
    error("Invalid literal")
end

local function ParseArray(Str, Idx)
    local Res = {}
    Idx = Idx + 1
    Idx = SkipWhitespace(Str, Idx)
    if Str:sub(Idx,Idx) == "]" then return Res, Idx + 1 end
    while true do
        local Val
        Val, Idx = Json.Parse(Str, Idx)
        Res[#Res+1] = Val
        Idx = SkipWhitespace(Str, Idx)
        local C = Str:sub(Idx,Idx)
        if C == "]" then return Res, Idx + 1 end
        if C ~= "," then error("Expected ',' in array") end
        Idx = SkipWhitespace(Str, Idx + 1)
    end
end

local function ParseObject(Str, Idx)
    local Res = {}
    Idx = Idx + 1
    Idx = SkipWhitespace(Str, Idx)
    if Str:sub(Idx,Idx) == "}" then return Res, Idx + 1 end
    while true do
        local Key
        if Str:sub(Idx,Idx) ~= '"' then error("Expected string key") end
        Key, Idx = ParseString(Str, Idx)
        Idx = SkipWhitespace(Str, Idx)
        if Str:sub(Idx,Idx) ~= ":" then error("Expected ':' after key") end
        Idx = SkipWhitespace(Str, Idx + 1)
        local Val
        Val, Idx = Json.Parse(Str, Idx)
        Res[Key] = Val
        Idx = SkipWhitespace(Str, Idx)
        local C = Str:sub(Idx,Idx)
        if C == "}" then return Res, Idx + 1 end
        if C ~= "," then error("Expected ',' in object") end
        Idx = SkipWhitespace(Str, Idx + 1)
    end
end

local function PrettyEncode(value, indent, level)
    indent = indent or 2
    level = level or 0
    local spacing = Rep(" ", level * indent)

    if type(value) == "table" then
        local isArray = (#value > 0)
        local parts = {}
        if isArray then
            for i, v in ipairs(value) do
                Insert(parts, PrettyEncode(v, indent, level + 1))
            end
            return "[\n" .. spacing .. Rep(" ", indent) ..
                Concat(parts, ",\n" .. spacing .. Rep(" ", indent)) ..
                "\n" .. spacing .. "]"
        else
            for k, v in pairs(value) do
                Insert(parts,
                    spacing .. Rep(" ", indent) ..
                    EscapeString(k) .. ": " .. PrettyEncode(v, indent, level + 1))
            end
            return "{\n" ..
                Concat(parts, ",\n") ..
                "\n" .. spacing .. "}"
        end
    elseif type(value) == "string" then
        return EscapeString(value)
    else
        return SerializeValue(value)
    end
end

function Json.Parse(Str, Idx)
    if type(Str) ~= "string" or #Str == 0 then
        error("Empty JSON string")
    end
    Idx = SkipWhitespace(Str, Idx or 1)
    local C = Str:sub(Idx, Idx)

    if C == '"' then
        return ParseString(Str, Idx)
    elseif C == "{" then
        return ParseObject(Str, Idx)
    elseif C == "[" then
        return ParseArray(Str, Idx)
    elseif C:match("[0-9%-]") then
        return ParseNumber(Str, Idx)
    elseif C:match("[tnf]") then
        return ParseLiteral(Str, Idx)
    else
        local ok, decoded = pcall(function()
            return (Base64Dec or Base64DecodeLua)(Str)
        end)
        if ok and decoded and #decoded > 0 and (decoded:sub(1,1) == "{" or decoded:sub(1,1) == "[") then
            return Json.Parse(decoded, 1)
        end
        if Str:sub(1,2) == "\x78\x9C" or Str:sub(1,2) == "\x78\xDA" then
            local ok2, unwrapped = pcall(function()
                return ZlibUnwrapUncompressed(Str)
            end)
            if ok2 and unwrapped and #unwrapped > 0 then
                return Json.Parse(unwrapped, 1)
            end
        end
        error("Unexpected character: " .. C)
    end
end

function Json.Validate(str)
    return pcall(function() Json.Parse(str) end)
end

function Json.PrettyEncode(value, indent)
    return PrettyEncode(value, indent or 2)
end

function Json.Encode(Value)
    return SerializeValue(Value)
end

function Json.Decode(Str)
    return DeserializeValue(Json.Parse(Str))
end
--

local Deflate = {}
Deflate.__index = Deflate

local function Split(String, Separator)
    local Result = {}
    for Part in String:gmatch("([^" .. Separator .. "]+)") do
        Result[#Result + 1] = Part
    end
    return Result
end

local function TryLoad(Path)
    local Success, Func = pcall(function()
        return load("return " .. Path)()
    end)
    if Success and type(Func) == "function" then
        return Func
    end
    return nil
end

local function FindFunction(Path)
    if type(Path) ~= "string" or Path == "" then
        return nil
    end

    local Func = TryLoad(Path)
    if Func then
        return Func
    end

    local Env = _G
    for _, Key in ipairs(Split(Path, "%.")) do
        if type(Env) ~= "table" and type(Env) ~= "userdata" then
            Env = nil
            break
        end
        local Ok, Val = pcall(function()
            return Env[Key]
        end)
        if not Ok then
            Env = nil
            break
        end
        Env = Val
        if Env == nil then break end
    end

    if type(Env) == "function" then
        return Env
    end
    return nil
end

local CompressorCandidates = {
    "syn.crypt.compress", "syn.crypto.compress", "syn.compress", "syn.deflate",
    "crypt.compress", "crypt.deflate", "compress", "zlib.compress", "zlib.deflate",
    "deflate.compress", "deflate"
}

local DecompressorCandidates = {
    "syn.crypt.decompress", "syn.crypto.decompress", "syn.decompress", "syn.inflate",
    "crypt.decompress", "crypt.inflate", "decompress", "zlib.decompress", "zlib.inflate",
    "deflate.decompress", "inflate"
}

local CompressFunction, DecompressFunction

for _, Path in ipairs(CompressorCandidates) do
    local F = FindFunction(Path)
    if F then
        CompressFunction = F
        break
    end
end

for _, Path in ipairs(DecompressorCandidates) do
    local F = FindFunction(Path)
    if F then
        DecompressFunction = F
        break
    end
end

local function Adler32(Data)
    local A, B = 1, 0
    for i = 1, #Data do
        A = (A + Data:byte(i)) % 65521
        B = (B + A) % 65521
    end
    return B * 2^16 + A
end

local function PackU32BE(Number)
    local Bytes = {}
    for i = 3, 0, -1 do
        Bytes[#Bytes + 1] = Char(bit.band(bit.rshift(Number, i * 8), 0xFF))
    end
    return Concat(Bytes)
end

local function PackU16LE(Number)
    local Lo = Number % 256
    local Hi = Floor(Number / 256) % 256
    return Char(Lo, Hi)
end

local function UnpackU16LE(String, Pos)
    Pos = Pos or 1
    local Lo = String:byte(Pos) or 0
    local Hi = String:byte(Pos + 1) or 0
    return Lo + Hi * 256
end

local function DeflateUncompressedBlock(Data)
    local Length = #Data
    if Length <= 0xFFFF then
        local LenLo = Length % 256
        local LenHi = Floor(Length / 256)
        local NLen = 0xFFFF - Length
        local NLenLo = NLen % 256
        local NLenHi = Floor(NLen / 256)
        return Char(1, LenLo, LenHi, NLenLo, NLenHi) .. Data
    end

    local Output, Index = {}, 1
    while Index <= Length do
        local Chunk = Data:sub(Index, Index + 65535 - 1)
        local Last = (Index + 65535 > Length)
        local BFinal = Last and 1 or 0
        local CLen = #Chunk
        local CLenLo = CLen % 256
        local CLenHi = Floor(CLen / 256)
        local NCLen = 0xFFFF - CLen
        local NCLenLo = NCLen % 256
        local NCLenHi = Floor(NCLen / 256)
        Output[#Output + 1] = Char(BFinal, CLenLo, CLenHi, NCLenLo, NCLenHi) .. Chunk
        Index = Index + 65535
    end
    return Concat(Output)
end

local function ZlibWrapUncompressed(Data)
    local Header = "\x78\x9C"
    local Body = DeflateUncompressedBlock(Data)
    local Adler = Adler32(Data)
    return Header .. Body .. PackU32BE(Adler)
end

local function ZlibUnwrapUncompressed(Data)
    assert(type(Data) == "string" and #Data >= 2, "Invalid zlib data")

    local Pos, OutputChunks = 3, {}

    while Pos <= #Data - 4 do
        local Hdr = Data:byte(Pos); Pos = Pos + 1
        
        local BFinal = bit.band(Hdr, 1)
        local BType  = bit.band(bit.rshift(Hdr, 1), 3)

        if BType == 0 then
            local Len  = UnpackU16LE(Data, Pos); Pos = Pos + 2
            local NLen = UnpackU16LE(Data, Pos); Pos = Pos + 2

            if bit.band(bit.bxor(Len, NLen), 0xFFFF) ~= 0xFFFF then
                error("Invalid uncompressed block lengths")
            end

            local Chunk = Data:sub(Pos, Pos + Len - 1)
            if #Chunk < Len then
                error("Incomplete uncompressed block")
            end
            OutputChunks[#OutputChunks + 1] = Chunk
            Pos = Pos + Len

            if BFinal == 1 then break end
        else
            error("Unsupported deflate block type: " .. tostring(BType))
        end
    end

    local ExpectedAdler = 0
    if Pos <= #Data - 3 then
        ExpectedAdler = bit.bor(
            bit.lshift((Data:byte(Pos)     or 0), 24),
            bit.lshift((Data:byte(Pos + 1) or 0), 16),
            bit.lshift((Data:byte(Pos + 2) or 0), 8),
            (Data:byte(Pos + 3) or 0)
        )
    end

    local Output = Concat(OutputChunks)
    if ExpectedAdler ~= 0 and Adler32(Output) ~= ExpectedAdler then
        error("Adler32 checksum mismatch")
    end

    return Output
end

local Base64Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local Base64Map = {}
for i = 1, #Base64Chars do
    Base64Map[Base64Chars:sub(i, i)] = i - 1
end

local function Base64EncodeLua(Data)
    if Data == "" then return "" end
    local Result = {}
    local Length = #Data
    local i = 1

    while i <= Length - 2 do
        local A, B, C = Data:byte(i, i + 2)
        local N = A * 65536 + B * 256 + C
        local C1 = Floor(N / 262144) % 64 + 1
        local C2 = Floor(N / 4096) % 64 + 1
        local C3 = Floor(N / 64) % 64 + 1
        local C4 = N % 64 + 1
        Result[#Result + 1] = Base64Chars:sub(C1, C1)
            .. Base64Chars:sub(C2, C2)
            .. Base64Chars:sub(C3, C3)
            .. Base64Chars:sub(C4, C4)
        i += 3
    end

    local Rem = Length - i + 1
    if Rem == 1 then
        local A = Data:byte(i)
        local N = A * 65536
        local C1 = Floor(N / 262144) % 64 + 1
        local C2 = Floor(N / 4096) % 64 + 1
        Result[#Result + 1] = Base64Chars:sub(C1, C1)
            .. Base64Chars:sub(C2, C2)
            .. "=="
    elseif Rem == 2 then
        local A, B = Data:byte(i, i + 1)
        local N = A * 65536 + B * 256
        local C1 = Floor(N / 262144) % 64 + 1
        local C2 = Floor(N / 4096) % 64 + 1
        local C3 = Floor(N / 64) % 64 + 1
        Result[#Result + 1] = Base64Chars:sub(C1, C1)
            .. Base64Chars:sub(C2, C2)
            .. Base64Chars:sub(C3, C3)
            .. "="
    end

    return Concat(Result)
end

local function Base64DecodeLua(Str)
    if type(Str) ~= "string" or #Str == 0 then
        return ""
    end
    local Output, Buffer, Bits = {}, 0, 0
    for i = 1, #Str do
        local Ch = Str:sub(i, i)
        if Ch == "=" then break end
        local Val = Base64Map[Ch]
        if Val ~= nil then
            Buffer = Buffer * 64 + Val
            Bits = Bits + 6
            while Bits >= 8 do
                Bits = Bits - 8
                local Byte = Floor(Buffer / (2 ^ Bits)) % 256
                if type(Byte) == "number" and Byte >= 0 and Byte <= 255 then
                    Output[#Output + 1] = Char(Byte)
                else
                    return Concat(Output)
                end
            end
        end
    end
    return Concat(Output)
end

local function FindBase64Functions()
    local Enc, Dec
    local Candidates = {
        "syn.crypt.base64.encode", "syn.crypt.base64.decode",
        "crypt.base64.encode", "crypt.base64.decode",
        "syn.crypt.base64_encode", "syn.crypt.base64_decode",
        "crypt.base64_encode", "crypt.base64_decode"
    }
    for i = 1, #Candidates, 2 do
        local EPath, DPath = Candidates[i], Candidates[i + 1]
        local E, D = FindFunction(EPath), FindFunction(DPath)
        if type(E) == "function" and type(D) == "function" then
            Enc, Dec = E, D
            break
        end
    end
    return Enc, Dec
end

local Base64Enc, Base64Dec = FindBase64Functions()
if not Base64Enc or not Base64Dec then
    Base64Enc = Base64EncodeLua
    Base64Dec = Base64DecodeLua
end

function Deflate.Compress(Data, Options)
    Options = Options or {}
    local Mode = Options.mode or "auto"
    local UseBase64 = Options.base64 == true

    if Mode == "auto" then
        if CompressFunction then
            local Ok, Result = pcall(CompressFunction, Data)
            if Ok then
                return UseBase64 and Base64Enc(Result) or Result
            end
        end
        local Wrapped = ZlibWrapUncompressed(Data)
        return UseBase64 and Base64Enc(Wrapped) or Wrapped
    elseif Mode == "executor" then
        assert(CompressFunction, "Executor compress not found")
        local Ok, Result = pcall(CompressFunction, Data)
        assert(Ok, "Executor compress failed")
        return UseBase64 and Base64Enc(Result) or Result
    elseif Mode == "zlib_uncompressed" then
        local Wrapped = ZlibWrapUncompressed(Data)
        return UseBase64 and Base64Enc(Wrapped) or Wrapped
    else
        error("Unknown compression mode: " .. tostring(Mode))
    end
end

function Deflate.Decompress(Data, Options)
    Options = Options or {}
    local Mode = Options.mode or "auto"
    local IsBase64 = Options.base64 == true

    local Raw = IsBase64 and Base64Dec(Data) or Data

    if Mode == "auto" then
        if DecompressFunction then
            local Ok, Result = pcall(DecompressFunction, Raw)
            if Ok then return Result end
        end
        local Ok, Result = pcall(ZlibUnwrapUncompressed, Raw)
        if Ok then return Result end
        error("No available decompressor")
    elseif Mode == "executor" then
        assert(DecompressFunction, "Executor decompress not found")
        local Ok, Result = pcall(DecompressFunction, Raw)
        assert(Ok, "Executor decompress failed")
        return Result
    elseif Mode == "zlib_uncompressed" then
        return ZlibUnwrapUncompressed(Raw)
    else
        error("Unknown decompression mode: " .. tostring(Mode))
    end
end

function Deflate.HasExecutor()
    return (CompressFunction ~= nil) or (DecompressFunction ~= nil)
end

Deflate._Internal = {
    CompressorFound = CompressFunction ~= nil,
    DecompressorFound = DecompressFunction ~= nil
}
--

-- utilities
do
	--
    do
	    local EnableTraceback = false
	    local Signal = {}
	    local Registry = { Signals = {}, Callbacks = {} }
	    Signal.__index = Signal
	    Signal.ClassName = "Signal"
	
	    function Signal.Create()
	        local self = setmetatable({}, Signal)
	        self.Bindable = Instance.new("BindableEvent")
	        self.ArgMap = {}
	        self.Source = EnableTraceback and debug.traceback() or ""
	        return self
	    end
	
	    function Signal:Fire(...)
	        if not self.Bindable then return end
	        local key = #self.ArgMap + 1
	        self.ArgMap[key] = { ... }
	        self.Bindable:Fire(key)
	    end
	
	    function Signal:Connect(fn)
		    assert(type(fn) == "function", "Signal:Connect expects a function")
		
		    return self.Bindable.Event:Connect(function(key)
		        local args = self.ArgMap[key]
		
		        if args == nil then
		            warn("[Signal] No arguments found for key:", key)
		            return  -- skip calling fn
		        end
		
		        self.ArgMap[key] = nil
		
		        if type(args) ~= "table" then
		            fn(args)  -- call with single value
		        else
		            fn(Unpack(args))  -- call with table values
		        end
		    end)
		end
	
	    function Signal:Wait()
	        local key = self.Bindable.Event:Wait()
	        local args = self.ArgMap[key]
	        self.ArgMap[key] = nil
	        return Unpack(args)
	    end
	
	    function Signal:Destroy()
	        if self.Bindable then
	            self.Bindable:Destroy()
	            self.Bindable = nil
	        end
	        setmetatable(self, nil)
	    end
	
	    function Signal.Add(name, fn)
	        if type(name) == "string" and type(fn) == "function" then
	            Registry.Callbacks[name] = fn
	        end
	    end
	
	    function Signal.Run(name, ...)
	        local cb = Registry.Callbacks[name]
	        if cb then
	            return cb(...)
	        end
	    end
	
	    function Signal.Remove(name)
	        Registry.Callbacks[name] = nil
	    end
	
	    function Signal.Wrap(name)
	        return function(...)
	            local sig = Signal.Get(name)
	            if sig and sig.Fire then
	                sig:Fire(...)
	            end
	        end
	    end
	
	    function Signal.New(name)
	        if type(name) ~= "string" then
	            return Signal.Create()
	        end
	        local segments = {}
	        for segment in Gmatch(name, "[^%.]+") do
	            Insert(segments, segment)
	        end
	        local cursor = Registry.Signals
	        for i = 1, #segments do
	            local part = segments[i]
	            if i == #segments then
	                if not cursor[part] then
	                    cursor[part] = Signal.Create()
	                end
	                return cursor[part]
	            else
	                cursor[part] = cursor[part] or {}
	                cursor = cursor[part]
	            end
	        end
	    end
	
	    function Signal.Get(name)
	        local segments = {}
	        for segment in Gmatch(name, "[^%.]+") do
	            Insert(segments, segment)
	        end
	        local cursor = Registry.Signals
	        for i = 1, #segments do
	            local part = segments[i]
	            cursor = cursor and cursor[part]
	            if not cursor then
	                return nil
	            end
	        end
	        return cursor
	    end
	    --
	    Utilities.Signal = Signal -- set to global utilities for further use
	end
	
	function Utilities.GetClipboard() -- pasted from vadderhaxx 🤑🤑
		local screen = Instance.new("ScreenGui",game.CoreGui)
		local tb = Instance.new("TextBox",screen)
		tb.TextTransparency = 1

		tb:CaptureFocus()
		keypress(0x11)  
		keypress(0x56)
		task.wait()
		keyrelease(0x11)
		keyrelease(0x56)
		tb:ReleaseFocus()

		local captured = tb.Text

		tb:Destroy()
		screen:Destroy()

		return captured
	end
    
    -- cool
    Utilities.Base = {
		AbsolutePosition = Vec2(0, 0),
		AbsoluteSize = Camera.ViewportSize,
		PropertyChanged = Utilities.Signal.New(),
		ChildUpdated = Utilities.Signal.New()
	}
	
    Utilities.BlockMouseEvents = false
	Utilities.Mouse = { -- so this is like are sorta own events that fire when mouse occur (pos, clicks, etc)
	    Position = Vec2(0, 0),
	    OldPosition = Vec2(0, 0),
	    Mouse1Held = false,
	    Mouse2Held = false,
	    Moved = Utilities.Signal.New(),
	    MouseButton1Down = Utilities.Signal.New(),
	    MouseButton1Up = Utilities.Signal.New(),
	    MouseButton2Down = Utilities.Signal.New(),
	    MouseButton2Up = Utilities.Signal.New(),
	    ScrollUp = Utilities.Signal.New(),
	    ScrollDown = Utilities.Signal.New()
	}
	
	Utilities.Activations = {
		Clicked = Utilities.Signal.New(),
		Holding = Utilities.Signal.New(),
		Hovering = Utilities.Signal.New(),
		MouseEnter = Utilities.Signal.New(),
		MouseLeave = Utilities.Signal.New()
	}
	
	Utilities.KeyDown = Utilities.Signal.New()
	Utilities.KeyUp = Utilities.Signal.New()
	Utilities.InputState = {Keys = {}}
	
	UserInputService.InputChanged:Connect(function(Input, Processed)
	    if Utilities.BlockMouseEvents then return end
	    if Input.UserInputType == Enum.UserInputType.MouseMovement then
	        Utilities.Mouse.OldPosition = Utilities.Mouse.Position
	        local XY = UserInputService:GetMouseLocation()
	        Utilities.Mouse.Position = Vec2(XY.X, XY.Y)
	        Utilities.Mouse.Moved:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.MouseWheel then
	        if Input.Position.Z > 0 then
	            Utilities.Mouse.ScrollUp:Fire(Input.Position.Z)
	        else
	            Utilities.Mouse.ScrollDown:Fire(Input.Position.Z)
	        end
	    end
	end)
	
	UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	    if GameProcessed then return end
	    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
	        Utilities.Mouse.Mouse1Held = true
	        Utilities.Mouse.MouseButton1Down:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
	        Utilities.Mouse.Mouse2Held = true
	        Utilities.Mouse.MouseButton2Down:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
	        Utilities.KeyDown:Fire(Input.KeyCode)
	        Utilities.InputState.Keys[Input.KeyCode] = true
	    end
	end)
	
	UserInputService.InputEnded:Connect(function(Input)
	    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
	        Utilities.Mouse.Mouse1Held = false
	        Utilities.Mouse.MouseButton1Up:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
	        Utilities.Mouse.Mouse2Held = false
	        Utilities.Mouse.MouseButton2Up:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
	        Utilities.KeyUp:Fire(Input.KeyCode)
	        Utilities.InputState.Keys[Input.KeyCode] = false
	    end
	end)
	
	--
	Utilities.Mouse.MouseButton1Down:Connect(function()
		Utilities.Activations.Clicked:Fire(nil, "Mouse", Utilities.Mouse.Position)
		Utilities.Activations.Holding:Fire(nil, true, "Mouse")
	end)
	
	Utilities.Mouse.MouseButton1Up:Connect(function()
		Utilities.Activations.Holding:Fire(nil, false, "Mouse")
	end)
	
	UserInputService.TouchTap:Connect(function(Touches)
		Utilities.Activations.Clicked:Fire(nil, "Touch", Touches[1])
	end)
	
	UserInputService.TouchLongPress:Connect(function(Touches, State)
		if State == Enum.UserInputState.Begin then
			Utilities.Activations.Holding:Fire(nil, true, "Touch")
		elseif State == Enum.UserInputState.End then
			Utilities.Activations.Holding:Fire(nil, false, "Touch")
		end
	end)
	
	Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		Utilities.Base.AbsoluteSize = Camera.ViewportSize
		Utilities.Base.PropertyChanged:Fire("AbsoluteSize", Camera.ViewportSize)
	end)
	
	-- now this is real pro
	setmetatable(Utilities.Base, {
	    __newindex = function(t, k, v)
	        local Old = rawget(t, k)
	        rawset(t, k, v)
	        t.PropertyChanged:Fire(k, v, Old)
	        t.ChildUpdated:Fire(k, v)
	    end
	})
    --
    
    --// functions
    do
	    local Functions = {}
	
	    function Functions:Create(Class, Properties)
			local obj = Instance.new(Class)
			for p, v in pairs(Properties or {}) do
				obj[p] = v
			end
			return obj
		end
		
		function Functions:Drawing(Class, Properties)
			local drawing = Drawing.new(Class)
			for p, v in pairs(Properties or {}) do
				obj[p] = v
			end
			return drawing
		end
		--
        Utilities.Functions = Functions -- set to global utilities for further use
    end
    
    -- Tasability
    do
	    local Tasability = {}
	
	    function Tasability.ClearAllFrames()
			Frames = {}
		    Index = 1
		    Frozen = false
		    Writing = false
		    Reading = false
            Paused = false
	    end
	
		function Tasability.ToggleFrozen()
			Frozen = not Frozen
		    Writing = not Frozen
	    end
	
		function Tasability.SpectateMode()
			Reading = false
		    Writing = false
			Frozen = false
            Paused = false
	    end
	
		function Tasability.CreateMode()
			Writing = true
			Reading = false
		    Frozen = true
	    end
	
		function Tasability.TestTasMode()
			Reading = true
		    Writing = false
			Frozen = false
            Paused = false
			Index = 1
	    end
	
		function Tasability.StepFrame(Direction)
            if #Frames == 0 then return end

            Index = Clamp(Index + Direction, 1, #Frames)
            local Frame = Frames[Index]
            if not Frame then return end

            HumanoidRootPart.CFrame = DeserializeValue(Frame[1])
            Camera.CFrame = DeserializeValue(Frame[2])
            HumanoidRootPart.Velocity = DeserializeValue(Frame[3])
            HumanoidRootPart.AssemblyLinearVelocity = DeserializeValue(Frame[4])
            HumanoidRootPart.AssemblyAngularVelocity = DeserializeValue(Frame[5])
            Humanoid:ChangeState(Enum.HumanoidStateType[Frame[6]])
            Utilities.CameraModule.UpdateZoom(tonumber(Frame[7]))

            if Direction < 0 then
                for i = #Frames, Index + 1, -1 do
                    Frames[i] = nil
                end
            end

            Frozen = true
        end
	
		function Tasability.GetReplayFiles()
		    local FolderPath = Library.Directory .. Library.Folders[1]
		    local Files = {}
		    for _, File in ipairs(listfiles(FolderPath)) do
		        local FileName = File:match("[^/\\]+$"):gsub("%.json$", "")
		       Insert(Files, FileName)
		    end
		    return Files
		end
	
		function Tasability.CreateFile(Name)
		    local FolderPath = Library.Directory .. Library.Folders[1]
		    local FilePath = FolderPath .. "/" .. Name .. ".json"
		
		    if isfile(FilePath) then
		        warn("File already exists: " .. FilePath)
		        return false
		    end
		
		    writefile(FilePath, "wow an empty file good job")
		    print("File created:", FilePath)
			return true
		end
		
		function Tasability.DeleteFile(Name)
            if Name and Name ~= "" then
                return
            end

		    local FolderPath = Library.Directory .. Library.Folders[1]
		    local FilePath = FolderPath .. "/" .. Name .. ".json"
		
		    if not isfile(FilePath) then
		        warn("File does not exist: " .. FilePath)
		        return false
		    end
		
		    delfile(FilePath)
		    print("File deleted:", FilePath)
		    return true
		end
	
		function Tasability.SaveFile(Name)
		    local FolderPath = Library.Directory .. Library.Folders[1]
		    local FilePath = FolderPath .. "/" .. Name .. ".json"
		
		    if not isfile(FilePath) then
		        warn("File does not exist: " .. FilePath)
		        return false
		    end
		
		    local Success, Encoded = pcall(function()
		        local jsonStr
		        if Library.PrettyFormatting then
		            jsonStr = Json.PrettyEncode(Frames, 4)
		        else
		            jsonStr = Json.Encode(Frames)
		        end
		
		        if Library.DeflateAlgorithm and Library.DeflateAlgorithm.Enabled then
		            return Deflate.Compress(jsonStr, {
		                mode = Library.DeflateAlgorithm.Mode or "auto",
		                base64 = Library.DeflateAlgorithm.Base64 or false
		            })
		        else
		            return jsonStr
		        end
		    end)
		
		    if not Success then
		        warn("Failed to encode Frames:", Encoded)
		        return false
		    end
		
		    writefile(FilePath, Encoded)
		    print("Saved TAS file:", FilePath, " (compressed =", tostring(Library.DeflateAlgorithm and Library.DeflateAlgorithm.enabled), ")")
		    return true
		end
		
		function Tasability.LoadFile(Name)
		    local FolderPath = Library.Directory .. Library.Folders[1]
		    local FilePath = FolderPath .. "/" .. Name .. ".json"
		
		    if not isfile(FilePath) then
		        warn("File does not exist: " .. FilePath)
		        return false
		    end
		
		    local Data = readfile(FilePath)
		    local DecodedData
		
		    local Success, Result = pcall(function()
		        if Library.DeflateAlgorithm and Library.DeflateAlgorithm.Enabled then
		            return Deflate.Decompress(Data, {
		                mode = Library.DeflateAlgorithm.Mode or "auto",
		                base64 = Library.DeflateAlgorithm.Base64 or false
		            })
		        else
		            return Data
		        end
		    end)
		
		    if not Success then
		        warn("Failed to decompress TAS file:", Result)
		        return false
		    end
		
		    local Parsed, _ = Json.Parse(Result)
		    if type(Parsed) ~= "table" then
		        warn("Invalid JSON in file:", Name)
		        return false
		    end
		
		    Frames = Parsed
		    print("Loaded TAS file:", FilePath, " (compressed =", tostring(Library.DeflateAlgorithm and Library.DeflateAlgorithm.enabled), ")")
		    return true
		end
		--
		Utilities.Tasability = Tasability -- set to global utilities for further use
    end
    
    -- C++ functions
    do
	    local KeySignal = {}
	
		function KeySignal:IsInstalled()
			return isfolder(Library.Directory .. Library.Folders[2])
		end
	
		function KeySignal:Send(Signal)
			if KeySignal:IsInstalled() then
				writefile(Library.Directory .. Library.Folders[2] .. "request.txt", Signal)
			else
				print("Request file/folder that sent inputs wasn't found??")
			end
		end
	
		Utilities.KeySignals = KeySignals -- set to global utilities for further use
    end
    
    -- camera
	do
		local CameraModule = {}
		CameraModule.__index = CameraModule
		CameraModule.ClassName = "ModuleScript"
		CameraModule.ZoomController = nil
		CameraModule.MouseLockController = nil

		-- closure scanner
		do
			local ZoomCount = 0
			local MouseLockCount = 0

			for _, obj in next, getgc(true) do
				if type(obj) == "table" then -- son you couldnt get the rel active zoom module LOL
					if rawget(obj, "Update") 
					and rawget(obj, "SetZoomParameters")
					and type(obj.Update) == "function"
					and type(obj.SetZoomParameters) == "function" then
						CameraModule.ZoomController = obj
						ZoomCount += 1
					elseif rawget(obj, "GetIsMouseLocked") and rawget(obj, "EnableMouseLock") then
						CameraModule.MouseLockController = obj
						MouseLockCount += 1
					end
				end
			end

			print(tostring(ZoomCount).." ZoomController"..(ZoomCount == 1 and "" or "s")..", "
				..tostring(MouseLockCount).." MouseLockController"..(MouseLockCount == 1 and "" or "s"))
		end

		-- zoom controller
		local ZoomSpringCache = nil
		local LastZoom = 12.5

		function CameraModule.GetZoom()
			local ZoomCtrl = CameraModule.ZoomController
			if not ZoomCtrl then
				return 12.5
			end

			if not ZoomSpringCache then
				local upvalues = getupvalues(ZoomCtrl.Update)
				for _, v in pairs(upvalues) do
					if type(v) == "table" and rawget(v, "x") and rawget(v, "goal") then
						ZoomSpringCache = v
						break
					end
				end
			end

			return ZoomSpringCache and ZoomSpringCache.x or 12.5
		end

		function CameraModule.UpdateZoom(Value)
			if CameraModule.ZoomController and Value ~= LastZoom then
				CameraModule.ZoomController.SetZoomParameters(Value, 0)
				LastZoom = Value
			end
		end

		function CameraModule.ReleaseZoom()
			if CameraModule.ZoomController and CameraModule.ZoomController.ReleaseSpring then
				CameraModule.ZoomController:ReleaseSpring()
			end
		end

		function CameraModule.SetCursor(CursorName)
			Library.Cursor.Image = Library.Cursors[CursorName].Image
			Library.Cursor.Size = Library.Cursors[CursorName].Size
		end

		-- shiftLock controller
		function CameraModule.GetShiftLock()
			local MouseLockController = CameraModule.MouseLockController
			if not MouseLockController then return false end

			if type(MouseLockController.GetIsMouseLocked) == "function" then
				local ok, v = pcall(function() return MouseLockController:GetIsMouseLocked() end)
				if ok then return v end
			end

			if type(MouseLockController.IsMouseLocked) == "function" then
				local ok, v = pcall(function() return MouseLockController:IsMouseLocked() end)
				if ok then return v end
			end

			if type(MouseLockController.isMouseLocked) == "boolean" then
				return MouseLockController.isMouseLocked
			end

			return false
		end

		function CameraModule.SetShiftLock(Value)
			local MouseLockController = CameraModule.MouseLockController
			if not MouseLockController then return end

			local Current = CameraModule.GetShiftLock()
			if Current == Value then return end

			if type(MouseLockController.OnMouseLockToggled) == "function" then
				pcall(function() MouseLockController:OnMouseLockToggled() end)
			elseif type(MouseLockController.isMouseLocked) == "boolean" then
				pcall(function() MouseLockController.isMouseLocked = Value end)
			end
		end

		Utilities.CameraModule = CameraModule -- set to global utilities for further use
	end
    --
end
--

-- functions
local function ToKeyCode(Key)
    if typeof(Key) == "EnumItem" and Key.EnumType == Enum.KeyCode then
        return Key
    end
    if type(Key) == "string" then
        local CleanKey = Key:lower():gsub("%s+", "")
        for _, EnumKey in pairs(Enum.KeyCode:GetEnumItems()) do
            if EnumKey.Name:lower() == CleanKey then
                return EnumKey
            end
        end
        warn("bro couldn't not find enumkey for string:", Key)
    end
    return nil
end

local function DeltaRound(n, decimals)
    local p = 10 ^ decimals
    return Floor(n * p + 0.5) / p
end
--

do -- Connections
	local PlaybackAccumulator = 0
	
	Library.Ignore = Utilities.Functions:Create("ScreenGui", {
		Name = "\0",
		DisplayOrder = 9999,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		IgnoreGuiInset = true,
		Parent = gethui()
	})

	Library.Holder = Utilities.Functions:Create("ScreenGui", {
		Name = "\0",
		DisplayOrder = 9999,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		IgnoreGuiInset = true,
		Parent = gethui()
	})

	Library.Cursor = Utilities.Functions:Create("ImageLabel", {
		Name = "okay",
		BackgroundTransparency = 1,
		ZIndex = 9999,
		AnchorPoint = Vec2(0.5, 0.5), 
		Parent = Library.Holder
	})

	pcall(function() -- ac bypasses
		local OldNameCall = nil
		local OldSpawn
		local SendRemote = ReplicatedStorage.DefaultChatSystemChatEvents.ChannelNameColorUpdated
		
		OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
			local NameCallMethod = getnamecallmethod()
			
			if not checkcaller() and Self == LocalPlayer and NameCallMethod == "Kick" then
				return nil
			end
		end)
		
		OldSpawn = hookfunction(getrenv().spawn, function(...)
			if not checkcaller() and (tostring(getcallingscript()) == "Animate" or tostring(getcallingscript()) == "RbxAnimateScript") then
				return OldSpawn(function()
					
				end)
			end
			
			return OldSpawn(...)
		end)
		
		SendRemote:Destroy()
		ReplicatedStorage.Remotes.Send:Destroy()
	end)

	-- set up
	Utilities.KeyDown:Connect(function(KeyCode)
		if KeyCode == ToKeyCode(Library.Keybind.Frozen) then
			Utilities.Tasability.ToggleFrozen()

		elseif KeyCode == ToKeyCode(Library.Keybind.Wipe) then
			Utilities.Tasability.ClearAllFrames()

		elseif KeyCode == ToKeyCode(Library.Keybind.Spectate) then
			Utilities.Tasability.SpectateMode()

		elseif KeyCode == ToKeyCode(Library.Keybind.Create) then
			Utilities.Tasability.CreateMode()

		elseif KeyCode == ToKeyCode(Library.Keybind.Test) then
			Utilities.Tasability.TestTasMode()

		elseif KeyCode == ToKeyCode(Library.MenuBind) then
			Window:ToggleVisibility()

		elseif KeyCode == ToKeyCode(Library.Keybind.StepBackward) then
			Utilities.Tasability.StepFrame(-1)

		elseif KeyCode == ToKeyCode(Library.Keybind.StepForward) then
			Utilities.Tasability.StepFrame(1)

		elseif KeyCode == ToKeyCode(Library.Keybind.Paused) then
			Paused = not Paused
			
		end
	end)

	Utilities.CameraModule.SetCursor("ArrowFarCursor")
	--

	-- mouse
	Insert(Library.Connections, RunService.RenderStepped:Connect(function()
		if Library.PlaybackMouseLocation and not Reading then
			local MouseLocation = UserInputService:GetMouseLocation()
			Library.Cursor.Position = DimOffset(MouseLocation.X, MouseLocation.Y)
		end
	end))

	-- reading
	Insert(Library.Connections, RunService.RenderStepped:Connect(function(Delta)
	    if Reading and not Writing and not Paused then
	        if not Character:FindFirstChild("HumanoidRootPart") then
	            return
	        end
	
	        PlaybackAccumulator += Delta
	
	        while Index <= #Frames do
	            local Frame = Frames[Index]
	            local FrameDelta = Frame[10]
	
				if FrameDelta <= 0 then
				    Index += 1
				    continue
				end
	
	            if PlaybackAccumulator < FrameDelta then
	                break
	            end
	
	            PlaybackAccumulator -= FrameDelta
	
	            local HumanoidRootPartCFrame = DeserializeValue(Frame[1])
	            local CameraCFrame = DeserializeValue(Frame[2])
	            local Velocity = DeserializeValue(Frame[3])
	            local AssemblyLinearVelocity = DeserializeValue(Frame[4])
	            local AssemblyAngularVelocity = DeserializeValue(Frame[5])
	            local State = Frame[6]
	            local Zoom = Frame[7]
	            local Shiftlock = Frame[8]
	            local MouseLocation = DeserializeValue(Frame[9])
	
	            HumanoidRootPart.CFrame = HumanoidRootPartCFrame
	            HumanoidRootPart.Velocity = Velocity
	            HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity
	            HumanoidRootPart.AssemblyAngularVelocity = AssemblyAngularVelocity
	            Camera.CFrame = CameraCFrame
	
	            if Library.PlaybackMouseLocation then
	                mousemoveabs(MouseLocation.X, MouseLocation.Y)
	            end
	
	            Humanoid:ChangeState(Enum.HumanoidStateType[State])
	            Utilities.CameraModule.UpdateZoom(tonumber(Zoom))
	            Utilities.CameraModule.SetShiftLock(Shiftlock)
	
	            Index += 1
	        end
	
	        if Index > #Frames then
	            Index = 1
	            Reading = false
	            PlaybackAccumulator = 0
	        end
	    end
	end))

	-- writing
	Insert(Library.Connections, RunService.PreSimulation:Connect(function(Delta)
		if Writing and not Reading and not Frozen then
			local HumanoidRootPartCFrame = HumanoidRootPart.CFrame
			local CameraCFrame = Camera.CFrame
			local Velocity = HumanoidRootPart.Velocity
			local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
			local AssemblyAngularVelocity = HumanoidRootPart.AssemblyAngularVelocity
			local State = Humanoid:GetState().Name
			local Zoom = Utilities.CameraModule.GetZoom()
			local Shiftlock = Utilities.CameraModule.GetShiftLock()
			local MouseLocation = UserInputService:GetMouseLocation()
			
			Insert(Frames, {
				HumanoidRootPartCFrame, --1
				CameraCFrame, --2
				Velocity, --3
				AssemblyLinearVelocity, --4
				AssemblyAngularVelocity, --5
				State, --6
				Zoom, --7
				Shiftlock, --8
				MouseLocation, --9
				DeltaRound(Delta, 6), --10
			})
			
			--
			Index = Index + 1
		end
	end))

	Insert(Library.Connections, RunService.RenderStepped:Connect(function()
		if not Reading then
			if Utilities.InputState.Keys[ToKeyCode(Library.Keybind.SeekBackward)] then
				Utilities.Tasability.StepFrame(-1)
			elseif Utilities.InputState.Keys[ToKeyCode(Library.Keybind.SeekForward)] then
				Utilities.Tasability.StepFrame(1)
			end
		end
	end))

	-- frozen
	Insert(Library.Connections, RunService.RenderStepped:Connect(function(Delta)
		HumanoidRootPart.Anchored = Frozen
		if Frozen and not Reading then
			local Frame = Frames[#Frames]
			if Frame then
				local HumanoidRootPartCFrame = DeserializeValue(Frame[1])
				local CameraCFrame = DeserializeValue(Frame[2])
				local Velocity = DeserializeValue(Frame[3])
				local AssemblyLinearVelocity = DeserializeValue(Frame[4])
				local AssemblyAngularVelocity = DeserializeValue(Frame[5])
				local State = Frame[6]
				local Zoom = Frame[7]
				local Shiftlock = Frame[8]
				local MouseLocation = DeserializeValue(Frame[9])
				
				HumanoidRootPart.CFrame = HumanoidRootPartCFrame
				HumanoidRootPart.Velocity = Velocity
				HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity
				HumanoidRootPart.AssemblyAngularVelocity = AssemblyAngularVelocity
				Camera.CFrame = CameraCFrame
				
				Humanoid:ChangeState(Enum.HumanoidStateType[State])
				Utilities.CameraModule.UpdateZoom(tonumber(Zoom)) -- tonumber useless but idaf 💔
			end
		end
	end))

	-- labels
	Insert(Library.Connections, RunService.RenderStepped:Connect(function()
		--[[if ReplayFile then
			CurrentReplayFile.Text = "Current replay file: " .. tostring(ReplayFile)
		else
			CurrentReplayFile.Text = "Current replay file: n/a"
		end
		CurrentFrameIndex.Text = "Current frame index: " .. tostring(Index)
		CurrentZoomValue.Text = "Current zoom value: " .. Floor(Utilities.CameraModule.GetZoom() * 100) / 100
		]]
	end))
	--

	LocalPlayer.CharacterAdded:Connect(function(char)
		Character = char
		HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
		Humanoid = char:WaitForChild("Humanoid")
	end)
end

--
local CallbackLists = {}; do
	CallbackLists["Main%%Playback Inputs"] = function(Value)
		Library.PlaybackInputs = Value
	end
	
	CallbackLists["Main%%Playback Mouse Location"] = function(Value)
		Library.PlaybackMouseLocation = Value
	end
	
	CallbackLists["Main%%Bypass Anticheat"] = function(Value)
		Library.BypassAntiCheat = Value
	end
	
	CallbackLists["Main%%Pretty Formatting"] = function(Value)
		Library.PrettyFormatting = Value
	end
	
	CallbackLists["Deflate Algorithm%%Enabled"] = function(Value)
		Library.DeflateAlgorithm.Enabled = Value
	end
	
	CallbackLists["Deflate Algorithm%%Base64"] = function(Value)
		Library.DeflateAlgorithm.Base64 = Value
	end
	
	CallbackLists["Deflate Algorithm%%Mode"] = function(Value)
		Library.DeflateAlgorithm.Mode = Value
	end
	
	CallbackLists["Hotkeys%%Spectate"] = function(Value)
		Library.Keybind.Spectate = Value
	end
	
	CallbackLists["Hotkeys%%Create"] = function(Value)
		Library.Keybind.Create = Value
	end
	
	CallbackLists["Hotkeys%%Test"] = function(Value)
		Library.Keybind.Test = Value
	end
	
	CallbackLists["Hotkeys%%Seek Backward"] = function(Value)
		Library.Keybind.SeekBackward = Value
	end
	
	CallbackLists["Hotkeys%%Seek Forward"] = function(Value)
		Library.Keybind.SeekForward = Value
	end
	
	CallbackLists["Hotkeys%%Step Backward"] = function(Value)
		Library.Keybind.StepBackward = Value
	end
	
	CallbackLists["Hotkeys%%Step Forward"] = function(Value)
		Library.Keybind.StepForward = Value
	end
	
	CallbackLists["Hotkeys%%Paused"] = function(Value)
		Library.Keybind.Pause = Value
	end
	
	CallbackLists["Hotkeys%%Frozen"] = function(Value)
		Library.Keybind.Frozen = Value
	end
	
	CallbackLists["Hotkeys%%Wipe"] = function(Value)
		Library.Keybind.Wipe = Value
	end
	
	CallbackLists["Settings%%Menu Bind"] = function(Value)
		Window:SetToggleKey(Enum.KeyCode[Value])
	end
	
	CallbackLists["Settings%%Anonymous"] = function(Value)
		Window.Icon:SetAnonymous(Value)
	end
	
	CallbackLists["Settings%%Transparency"] = function(Value)
		Window:ToggleTransparency(Value)
	end
	
	CallbackLists["Developer%%Get Window Size"] = function()
		local size = WindUI:GetWindowSize()
        setclipboard(Format("Dim2(%s, %s, %s, %s)", size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset))
	end
	
	Library.Unload = function()
		for _, Connection in ipairs(Library.Connections) do
			if typeof(Connection) == "RBXScriptConnection" then
				Connection:Disconnect()
			end
		end
	
		Library.Connections = {}
		Reading = false
		Writing = false
		Frozen = false
		Paused = false
		Index = 1
	end
end
--

local Window = WindUI:CreateWindow{Title = "Tasablity - Nymera", Folder = "NymeraTas", Size = DimOffset(645, 450), MinSize = Vec2(560, 350), MaxSize = Vec2(850, 560), HideSearchBar = false, User = {Enabled = true, Anonymous = false}} do
	local ConfigManager = Window.ConfigManager
	local Config = ConfigManager:CreateConfig("Settings")

	function GetCallback(Name)
	    return function(...)
	        local Callback = CallbackLists[Name]
	        if Callback then
	            Callback(...)
	        end
	    end
	end
	
	local Section = Window:Tab{Title = "Record", Icon = "rbxassetid://130475528794903"} do
		Section:Section{Title = "Recording"}
		
		Section:Section{Title = "Configuration"}
		Section:Toggle{Title = "Playback Inputs", Flag = "PlaybackInputs", Desc = "Playback you're inputs when reading.", Type = "Toggle", Callback = GetCallback("Main%%Playback Inputs")}
		Section:Toggle{Title = "Playback Mouse Location", Flag = "PlaybackMouseLocation", Desc = "Playback you're mouse locatiom when reading.", Type = "Toggle", Callback = GetCallback("Main%%Playback Mouse Location")}
		Section:Toggle{Title = "Bypass Anti Cheat", Flag = "BypassAntiCheat", Desc = "Bypasses some anti cheat.", Type = "Toggle", Callback = GetCallback("Main%%Bypass Anticheat")}
		Section:Toggle{Title = "Pretty Formatting", Flag = "PrettyFormatting", Desc = "Pretty format the file when saving.", Type = "Toggle", Callback = GetCallback("Main%%Pretty Formatting")}
		
		Section:Section{Title = "Deflate Algorithm."}
		Section:Toggle{Title = "Enabled", Value = Library.DeflateAlgorithm.Enabled, Flag = "DeflateEnabled", Desc = "Enables the deflate compression algorithm for data processing.", Type = "Toggle", Callback = GetCallback("Deflate Algorithm%%Enabled")}
		Section:Toggle{Title = "Base64", Value = Library.DeflateAlgorithm.Base64, Flag = "DeflateBase64", Desc = "Encodes the compressed output using Base64 for safer transmission and compatibility.", Type = "Toggle", Callback = GetCallback("Deflate Algorithm%%Base64")}
		Section:Dropdown{Title = "Mode", Value = Library.DeflateAlgorithm.Mode, Flag = "DeflateMode", Desc = "Selects how deflate compression is handled based on the execution environment.", Values = {"executor", "auto", "zlib_uncompressed"}, Callback = GetCallback("Deflate Algorithm%%Mode")}
	end
	
	local Section = Window:Tab{Title = "Hotkeys.", Icon = "rbxassetid://121474456068237"} do
		Section:Section{Title = "Hotkeys"}
		Section:Keybind{Title = "Spectate", Value = Library.Keybind.Spectate, Flag = "Spectate", Callback = GetCallback("Hotkeys%%Spectate")}
		Section:Keybind{Title = "Create", Value = Library.Keybind.Create, Flag = "Create", Callback = GetCallback("Hotkeys%%Create")}
		Section:Keybind{Title = "Test", Value = Library.Keybind.Test, Flag = "Test", Callback = GetCallback("Hotkeys%%Test")}
		Section:Keybind{Title = "Seek Backward", Value = Library.Keybind.SeekBackward, Flag = "SeekBackward", Callback = GetCallback("Hotkeys%%Seek Backward")}
		Section:Keybind{Title = "Seek Forward", Value = Library.Keybind.SeekForward, Flag = "SeekForward", Callback = GetCallback("Hotkeys%%Seek Forward")}
		Section:Keybind{Title = "Step Backward", Value = Library.Keybind.StepBackward, Flag = "StepBackward", Callback = GetCallback("Hotkeys%%Step Backward")}
		Section:Keybind{Title = "Step Forward", Value = Library.Keybind.StepForward, Flag = "StepForward", Callback = GetCallback("Hotkeys%%Step Forward")}
		Section:Keybind{Title = "Paused", Value = Library.Keybind.Pause, Flag = "Pause", Callback = GetCallback("Hotkeys%%Pause")}
		Section:Keybind{Title = "Frozen", Value = Library.Keybind.Frozen, Flag = "Frozen", Callback = GetCallback("Hotkeys%%Frozen")}
		Section:Keybind{Title = "Wipe", Value = Library.Keybind.Wipe, Flag = "Wipe", Callback = GetCallback("Hotkeys%%Wipe")}
	end
	
	Window:Divider()
	local Section = Window:Tab{Title = "Settings.", Icon = "rbxassetid://80758916183665", Locked = false} do
		Section:Section{Title = "Interface"}
		Section:Keybind{Title = "Menu Bind", Value = "M", Flag = "MenuBind", Callback = GetCallback("Settings%%Menu Bind")}
		
		Section:Section{Title = "Main"}
		Section:Toggle{Title = "Anonymous", Flag = "Anonymous", Desc = "Set your profile to anonymous.", Type = "Toggle", Callback = GetCallback("Settings%%Anonymous")}
		Section:Toggle{Title = "Transparency", Flag = "Transparency", Value = true, Desc = "Set the gui transparent.", Type = "Toggle", Callback = GetCallback("Settings%%Transparency")}
		
		Section:Section{Title = "Configuration."}
		Section:Button{Title = "Save", Desc = "Saves every elements inside the ui.", Callback = function() Config:Save() end}
		Section:Button{Title = "Delete", Desc = "Sets every elements value default inside the ui.", Callback = function() Config:Delete() task.wait() Config:Load() end}
	end
	
	if DevMode then
		Section:Section{Title = "Developer."}
		Section:Paragraph{Title = "READ ME", Desc = "If you're reading this, then don't touch anything otherwise something will fuck up everything unless you know what you're doing."}
		Section:Button{Title = "Get Window Size", Callback = GetCallback("Developer%%Get Window Size")}
	end
	
	Window:ToggleTransparency(true)
	Window:Tag{Title = Version, Color = Hex("#30ff6a"), Radius = 13}
	Window:Tag{Title = ".gg/", Color = Hex("#7289da"), Radius = 13}
	
	Window:EditOpenButton{
	    Title = "Tasablity",
	    CornerRadius = Dim(0,16),
	    StrokeThickness = 2,
	    Color = RgbSeq(Hex("FF0F7B"), Hex("F89B29")),
	    OnlyMobile = true,
	    Enabled = true,
	    Draggable = true,
	}
	
	task.wait()
	Config:Load()
end
--

for i = 1, 3 do -- unnecessary but i like it
	task.wait()
end
-- man i just wnna kms :pensive:
