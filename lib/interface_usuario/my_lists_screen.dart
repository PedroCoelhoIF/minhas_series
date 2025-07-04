import 'package:flutter/material.dart';
import 'package:minhas_series/bd/database_helper.dart';
import 'package:minhas_series/widgets/serie_card.dart';

class MyListsScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const MyListsScreen({super.key, required this.user});

  @override
  State<MyListsScreen> createState() => _MyListsScreenState();
}

class _MyListsScreenState extends State<MyListsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final dbHelper = DatabaseHelper();

 
  void _refreshData() {
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildSeriesList(String status) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getSeriesByStatus(status, widget.user['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma série nesta lista ainda.'));
        }
        final seriesList = snapshot.data!;
        return ListView.builder(
          itemCount: seriesList.length,
          itemBuilder: (context, index) {
            return SerieCard(
              series: seriesList[index],
              user: widget.user,
              onRefresh: _refreshData, 
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Listas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Assistindo'),
            Tab(text: 'Quero Ver'),
            Tab(text: 'Já Vi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSeriesList('watching'),
          _buildSeriesList('planned'),
          _buildSeriesList('finished'),
        ],
      ),
    );
  }
}