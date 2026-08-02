import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/certification/cubits/certification_cubit.dart';
import 'package:immoplus_pro/features/certification/models/certification_model.dart';

class CertificationPage extends StatefulWidget {
  static const String name = 'CERTIFICATION_PAGE';
  static const String routePath = '/certification';

  const CertificationPage({super.key});

  @override
  State<CertificationPage> createState() => _CertificationPageState();
}

class _CertificationPageState extends State<CertificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<CertificationCubit>().loadCertification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Certification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CertificationCubit, RequestState>(
        builder: (context, state) {
          if (state is REQUEST_LOADING || state is REQUEST_INITIAL) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CERTIFICATION) {
            return _buildContent(context, state.data);
          }

          if (state is REQUEST_ERROR) {
            return Center(
              child: Text(
                'Erreur: ${state.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CertificationModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Text(
            'Votre niveau de confiance auprès des locataires',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const Gap(20),

          // Score section
          _buildScoreSection(data),
          const Gap(30),

          // KPI Cards
          _buildKPICards(data),
          const Gap(30),

          // Conditions d'attribution
          Text(
            'Évolution des revenus',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Gap(16),
          _buildConditionsChecklist(data),
          const Gap(30),

          // Action button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: AppColors.primary),
              ),
              child: Text(
                'Retour',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Gap(20),
        ],
      ),
    );
  }

  Widget _buildScoreSection(CertificationModel data) {
    final percentage = (data.scoreTotal / 100) * 100;
    final level = _getLevelFromScore(data.scoreTotal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${data.scoreTotal}/100 ${level['name']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const Gap(12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(level['color'] as Color),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICards(CertificationModel data) {
    final tauxReponse = data.piliers.fiabilite.tauxReponse ?? 0.0;
    final nbReservations = data.piliers.reservations.nbReservationsEffectuees ?? 0;
    final delaiMedian = data.piliers.fiabilite.delaiMedianMinutes ?? 0;

    final kpis = [
      {
        'label': 'Taux d\'acceptation',
        'value': '${tauxReponse.toStringAsFixed(0)}%',
        'color': Colors.green,
      },
      {
        'label': 'Taux de refus',
        'value': '${(100 - tauxReponse).toStringAsFixed(0)}%',
        'color': Colors.red,
      },
      {
        'label': 'Temps de réponse',
        'value': '$delaiMedian',
        'color': Colors.black,
      },
      {
        'label': 'Transactions',
        'value': '$nbReservations',
        'color': Colors.black,
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: kpis.map((kpi) {
        return _buildKPICard(
          label: kpi['label'] as String,
          value: kpi['value'] as String,
          color: kpi['color'] as Color,
        );
      }).toList(),
    );
  }

  Widget _buildKPICard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsChecklist(CertificationModel data) {
    final conditions = [
      {
        'label': 'Identité vérifiée',
        'completed': data.conditionsAttribution.identiteVerifiee,
      },
      {
        'label': '20 transactions minimum',
        'completed': data.conditionsAttribution.reservationsMin10,
      },
      {
        'label': 'Taux d\'acceptation supérieur à 90%',
        'completed': data.conditionsAttribution.avisMinimum,
      },
      {
        'label': 'Aucun litige sur 6 mois',
        'completed': data.conditionsAttribution.aucuneSanctionActive,
      },
    ];

    return Column(
      children: conditions.map((condition) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: condition['completed'] == true
                        ? Colors.green
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: condition['completed'] == true
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.green,
                      )
                    : null,
              ),
              const Gap(12),
              Text(
                condition['label'] as String,
                style: TextStyle(
                  fontSize: 14,
                  color: condition['completed'] == true
                      ? Colors.black
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> _getLevelFromScore(int score) {
    if (score >= 85) {
      return {
        'name': 'Or',
        'color': const Color(0xFFFFD700),
      };
    } else if (score >= 70) {
      return {
        'name': 'Argent',
        'color': const Color(0xFFC0C0C0),
      };
    } else if (score >= 50) {
      return {
        'name': 'Bronze',
        'color': const Color(0xFFCD7F32),
      };
    } else {
      return {
        'name': 'Novice',
        'color': Colors.grey,
      };
    }
  }
}
