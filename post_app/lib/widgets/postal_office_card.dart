import 'package:flutter/material.dart';

class PostalOfficeCard extends StatelessWidget {
  const PostalOfficeCard({
    required this.branchNumber,
    required this.address,
    required this.workingHours,
    super.key,
  });

  final String branchNumber;
  final String address;
  final String workingHours;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              branchNumber,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(address),
            const SizedBox(height: 6),
            Text(workingHours),
          ],
        ),
      ),
    );
  }
}