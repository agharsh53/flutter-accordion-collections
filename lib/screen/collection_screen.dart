import 'package:flutter/material.dart';
import '../data/collection_data.dart';
import '../models/collection_model.dart';
import '../widget/collection_card.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<Collection> _collections = [];
  String? _expandedCollectionId;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  void _loadCollections() {
    setState(() {
      _collections = CollectionData.collections;
    });
  }

  void _toggleCollection(String collectionId) {
    setState(() {
      if (_expandedCollectionId == collectionId) {
        _expandedCollectionId = null;
      } else {
        _expandedCollectionId = collectionId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Collections',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,

        ),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _collections.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _collections.length,
        separatorBuilder: (context, index) =>
        const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final collection = _collections[index];
          final isExpanded = _expandedCollectionId == collection.id;

          return CollectionCard(
            collection: collection,
            isExpanded: isExpanded,
            onTap: () => _toggleCollection(collection.id),
          );
        },
      ),
    );
  }
}