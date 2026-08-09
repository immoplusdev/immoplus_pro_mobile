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
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
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

          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
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
          const Gap(24),

          // KPI Cards
          _buildKPICards(data),
          const Gap(30),

          // Conditions d'attribution
          const Text(
            'Critères de certification',
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
    final percentage = (data.scoreTotal / 100).clamp(0.0, 1.0);
    final level = _getLevelFromScore(data.scoreTotal);
    final levelColor = level['color'] as Color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data.scoreTotal}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 4),
                child: Text(
                  '/100',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const Spacer(),
              _buildLevelChip(level['name'] as String, levelColor),
            ],
          ),
          const Gap(16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percentage),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 12,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelChip(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded, size: 14, color: color),
          const Gap(4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards(CertificationModel data) {
    final tauxReponse = data.piliers.fiabilite.tauxReponse ?? 0.0;
    final nbReservations =
        data.piliers.reservations.nbReservationsEffectuees ?? 0;
    final delaiMedian = data.piliers.fiabilite.delaiMedianMinutes ?? 0;

    final kpis = [
      _KpiData(
        label: "Taux d'acceptation",
        value: '${tauxReponse.toStringAsFixed(0)}%',
        icon: Icons.thumb_up_alt_rounded,
        color: AppColors.green1CA53F,
      ),
      _KpiData(
        label: 'Taux de refus',
        value: '${(100 - tauxReponse).toStringAsFixed(0)}%',
        icon: Icons.thumb_down_alt_rounded,
        color: AppColors.redFF0000,
      ),
      _KpiData(
        label: 'Temps de réponse',
        value: '$delaiMedian min',
        icon: Icons.timer_rounded,
        color: AppColors.primary,
      ),
      _KpiData(
        label: 'Transactions',
        value: '$nbReservations',
        icon: Icons.receipt_long_rounded,
        color: AppColors.primary,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: kpis.map(_buildKPICard).toList(),
    );
  }

  Widget _buildKPICard(_KpiData kpi) {
    return Container(
      decoration: BoxDecoration(
        color: kpi.color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kpi.color.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kpi.color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(kpi.icon, size: 16, color: kpi.color),
          ),
          const Gap(10),
          Text(
            kpi.value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: kpi.color,
            ),
          ),
          const Gap(2),
          Text(
            kpi.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsChecklist(CertificationModel data) {
    final conditions = [
      _ConditionData(
        label: 'Identité vérifiée',
        completed: data.conditionsAttribution.identiteVerifiee,
      ),
      _ConditionData(
        label: '20 transactions minimum',
        completed: data.conditionsAttribution.reservationsMin10,
      ),
      _ConditionData(
        label: "Taux d'acceptation supérieur à 90%",
        completed: data.conditionsAttribution.avisMinimum,
      ),
      _ConditionData(
        label: 'Aucun litige sur 6 mois',
        completed: data.conditionsAttribution.aucuneSanctionActive,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(conditions.length, (i) {
          final condition = conditions[i];
          final isLast = i == conditions.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: condition.completed
                            ? AppColors.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: condition.completed
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: condition.completed
                          ? const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        condition.label,
                        style: TextStyle(
                          fontSize: 14,
                          color: condition.completed
                              ? Colors.black87
                              : Colors.grey.shade600,
                          fontWeight: condition.completed
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
            ],
          );
        }),
      ),
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

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _ConditionData {
  final String label;
  final bool completed;

  const _ConditionData({
    required this.label,
    required this.completed,
  });
}
