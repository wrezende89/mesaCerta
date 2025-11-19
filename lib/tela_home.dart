import 'package:aula1/Banco/restauranteDAO.dart';
import 'package:aula1/Banco/usuarioDAO.dart';
import 'package:aula1/restaurante.dart';
import 'package:flutter/material.dart';

class telaHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => telaHomeState();
}

class telaHomeState extends State<telaHome> {
  final nome = UsuarioDAO.usuarioLogado.nome;

  List<Restaurante> restaurantes = [];
  
  // --- MOCK DATA PARA FILTROS COM IMAGENS (Usando URLs de bandeiras) ---
  final List<Map<String, dynamic>> cuisines = [
    {'name': 'Mexicana', 'image_url': 'https://flagcdn.com/w80/mx.png'},
    {'name': 'Árabe', 'image_url': 'https://flagcdn.com/w80/sa.png'},
    {'name': 'Francesa', 'image_url': 'https://flagcdn.com/w80/fr.png'},
    {'name': 'Portuguesa', 'image_url': 'https://flagcdn.com/w80/pt.png'},
    {'name': 'Italiana', 'image_url': 'https://flagcdn.com/w80/it.png'},
    {'name': 'Japonesa', 'image_url': 'https://flagcdn.com/w80/jp.png'},
  ];

  Future<void> carregarRestaurantes() async {
    final lista = await RestauranteDAO.listarTodos();
    setState(() {
      restaurantes = lista;
    });
  }

  @override
  void initState() {
    super.initState();
    carregarRestaurantes();
  }

  bool isDarkMode = false;
  int selectedIndex = 0;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Lógica de navegação
  }

  @override
  Widget build(BuildContext context) {
    // Cores Azuis
    final Color primaryColor = Colors.blue; 
    final Color darkPrimaryColor = Colors.blue.shade700; 
    final Color scaffoldBackgroundColor =
        isDarkMode ? Colors.black87 : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: primaryColor), 

      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              // 1. CABEÇALHO (HEADER)
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16), 
                decoration: BoxDecoration(
                  color: primaryColor, 
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- LINHA SUPERIOR DO CABEÇALHO ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ícone do Menu Sanduíche
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.white, size: 28),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        // Logo do Aplicativo e Slogan (MESA CERTA)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo.png', // Caminho do logo do app
                                height: 40,
                                errorBuilder: (context, error, stackTrace) {
                                  print(
                                      "Erro ao carregar logo do app: assets/logo.png - $error");
                                  // NOME DO APP ATUALIZADO
                                  return Text('Mesa Certa', 
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold));
                                },
                              ),
                              SizedBox(width: 10),
                              // Slogan do Serviço ATUALIZADO
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: darkPrimaryColor, 
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Conectando você ao prato perfeito.', // <-- NOVO SLOGAN!
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Sino de Notificação
                        IconButton(
                          icon: Icon(Icons.notifications_none,
                              color: Colors.white, size: 28),
                          onPressed: () {
                            // Ação do sino
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. TÍTULO DO FILTRO DE CULINÁRIA
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16.0),
                child: Text(
                  'Qual a sua culinária favorita?',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ),

              // 3. FILTROS HORIZONTAIS COM BANDEIRAS
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: cuisines.length,
                  itemBuilder: (context, index) {
                    final cuisine = cuisines[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Image.network(
                                cuisine['image_url'] as String,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: primaryColor.withOpacity(0.1), 
                                    child: Icon(Icons.flag,
                                        size: 30, color: primaryColor),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            cuisine['name'] as String,
                            style: TextStyle(fontSize: 12, color: textColor),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ],
      ),

      // --- BARRA DE NAVEGAÇÃO INFERIOR ---
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: primaryColor, 
        unselectedItemColor: Colors.grey,
        backgroundColor: scaffoldBackgroundColor,
        onTap: onItemTapped,
      ),
    );
  }
}